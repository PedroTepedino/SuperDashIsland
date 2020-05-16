using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using FMODUnity;
using System;

[RequireComponent(typeof(Rigidbody))]
public class PlayerController : MonoBehaviour, IPushableObject
{
    protected Vector3 _collisionForce;
    //[EventRef] [SerializeField] protected string _hitSound;
    protected bool _colliding = false;

    #region Move Parameters
    [BoxGroup("Paremeters")] [FoldoutGroup("Paremeters/Move")] [SerializeField] private float _moveSpeed = 20f;
    #endregion

    #region Rotation Parameters
    [FoldoutGroup("Paremeters/Rotation")] [SerializeField] private float _rotationSpeed = 20f;
    private Quaternion _lastRotation = Quaternion.identity;
    #endregion

    #region Dash Parameters
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private float _minTimeChargedDash = 0.5f;
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private float _standardDashTime = 0.25f;
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private float _meteoreDashTime = 0.75f;
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private float _chargedDashTime = 1.0f;
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private float _dashSpeed = 20f;
    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private GameObject _dashingEffect;
    [FoldoutGroup("Paremeters/Sounds")] [SerializeField] [EventRef] private string _dashSound;

    private Coroutine _dashCoroutine = null;
    private Vector3 _curentDashDirection = Vector3.zero;

    private DashType _curentDashType = DashType.Null;

    [FoldoutGroup("Paremeters/Dash")] [SerializeField] private DashTypeFloatPair[] _dashTypesList;
    private Dictionary<DashType, float> _dashForces;

    public Action<bool> OnDash;

    private enum DashType { Null = 0, Standard = 1 << 0, Charged = 1 << 1, Meteore = 1 << 2 }
    [Serializable]
    private struct DashTypeFloatPair
    {
        [EnumToggleButtons] public DashType DashType;
        public float Force;
    }
    #endregion

    #region Push Parameters
    private Vector3 _curentForceToApply = Vector3.zero;
    #endregion

    #region Colision Parameters
    [FoldoutGroup("Paremeters/Sounds")] [SerializeField] [EventRef] private string _hitSound;
    public static Action OnPush;
    #endregion

    #region PushStun Parameters
    public Action<bool> OnPushStun;
    private bool _isStuned = false;
    #endregion

    #region Not Grounded Parameters
    [FoldoutGroup("Paremeters/Grounder")] [SerializeField] private float _forceToApplyVerticaly = -100f;
    private Grounder _playerGrounder;
    private bool _isGrounded = true;
    #endregion

    #region Object Parameters
    private Rigidbody _rigidbody;
    private Animator _playerAnimatorController;
    private PlayerInputManeger _playerInputManager;
    #endregion

    #region PowerUp
    [ShowInInspector] private PowerUp _powerUp = null;
    public bool HasPowerUp { get => _powerUp != null; }
    public PowerUpTypes PowerUpType { get => _powerUp.Type; }
    #endregion

    private void Awake()
    {
        SetDashTypeDictionary();

        GetEssencialComponents();
        SetActionsCallBacks();
    }

    private void OnEnable()
    {
        _isStuned = false;
    }

    private void OnDestroy()
    {
        RemoveActionCallbacks();
    }

    private void OnDisable()
    {
        this.StopAllCoroutines();
    }

    private void Update()
    {
        this.SetAnimation("speed", this._rigidbody.velocity.magnitude);

        AddGrounderForce();
    }

    private void FixedUpdate()
    {
        DashVelocitySetAndReiteration();
        CheckPushStuned();
    }

    private void LateUpdate()
    {
        ApplyForce();
        ResetForceToAply();
    }

    private void OnCollisionEnter(Collision collision)
    {
        PushProcess(collision, playsound: true);
    }

    private void OnCollisionStay(Collision collision)
    {
        PushProcess(collision);
    }

    private void GetEssencialComponents()
    {
        this._rigidbody = this.GetComponentInObject<Rigidbody>();
        this._playerAnimatorController = this.GetComponentInObject<Animator>();
        this._playerGrounder = this.GetComponentInObject<Grounder>();
        this._playerInputManager = this.GetComponentInObject<PlayerInputManeger>();
    }

    private void SetActionsCallBacks()
    {
        this._playerGrounder.OnGrounded += ListenGrounder;
    }

    private void RemoveActionCallbacks()
    {
        this._playerGrounder.OnGrounded -= ListenGrounder;
    }

    private T GetComponentInObject<T>()
    {
        T value = this.gameObject.GetComponentInChildren<T>();

        if (value == null)
        {
            value = this.gameObject.GetComponentInParent<T>();
        }

        return value;
    }

    public bool CanCharge()
    {
        if (this._rigidbody.velocity.magnitude >= this._moveSpeed)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public void Charge(bool justStartedCharge = false)
    {
        if (justStartedCharge)
        {
            StopPlayerMovement();
        }

        this.SetAnimation("Charging", true);
    }

    public void HaltCharge()
    {
        this.SetAnimation("Charging", false);
    }

    public void Dash(float chargeTime, Vector3 moveDirection)
    {
        this.SetAnimation("Dashing", true);
        this.SetAnimation("Charging", false);

        if (CheckMeteorePowerUp() == true)
        {
            _curentDashType = DashType.Meteore;
            _powerUp.RemovePowerUp(this);
        }
        else
        {
            SetDashType(chargeTime);
        }

        _dashCoroutine = StartCoroutine(DashingProcess(dashDirection: GetDashDirection(moveDirection), dashTime: GetDashTime(_curentDashType)));
    }

    private bool CheckMeteorePowerUp()
    {
        if (_powerUp != null)
        {
            if (_powerUp.Type == PowerUpTypes.Meteore)
            {
                return true;
            }
        }

        return false;
    }

    private IEnumerator DashingProcess(Vector3 dashDirection, float dashTime)
    {
        StartDashing(dashDirection);
        yield return new WaitForSeconds(dashTime);
        EndDashing();
    }

    private void DashVelocitySetAndReiteration()
    {
        if (_dashCoroutine != null)
        {
            this._rigidbody.velocity = _curentDashDirection * _dashSpeed;
        }
    }

    private void StartDashing(Vector3 dashDirection)
    {
        OnDash?.Invoke(true);
        PlaySound(_dashSound);
        _dashingEffect.SetActive(true);

        this._rigidbody.velocity = dashDirection.normalized * _dashSpeed;
        _curentDashDirection = dashDirection.normalized;
    }

    private void EndDashing()
    {
        this.SetAnimation("Dashing", false);
        _curentDashType = DashType.Null;
        _dashingEffect.SetActive(false);

        _dashCoroutine = null;
        _curentDashDirection = Vector3.zero;

        OnDash?.Invoke(false);
    }

    public void HaltDash()
    {
        StopCoroutine("DashingProcess");
        EndDashing();
    }

    private Vector3 GetDashDirection(Vector3 moveDirection)
    {
        if (moveDirection.magnitude != 0)
        {
            return moveDirection;
        }
        else
        {
            float angle = (360 - this.transform.rotation.eulerAngles.y) * Mathf.Deg2Rad;
            return new Vector3(Mathf.Cos(angle), 0f, Mathf.Sin(angle));
        }
    }


    private void SetDashType(float chargeTime)
    {
        if (_curentDashType == DashType.Null)
        {
            if (chargeTime >= _minTimeChargedDash)
            {
                _curentDashType = DashType.Charged;
            }
            else
            {
                _curentDashType = DashType.Standard;
            }
        }
    }

    private float GetDashTime(DashType dashType)
    {
        if (dashType == DashType.Meteore)
        {
            return _meteoreDashTime;
        }
        if (dashType == DashType.Standard)
        {
            return _standardDashTime;
        }
        else
        {
            return _chargedDashTime;
        }
    }

    public void MovePlayer(Vector3 moveDirection)
    {
        moveDirection = moveDirection.normalized * _moveSpeed;
        moveDirection.y = this._rigidbody.velocity.y;
        this._rigidbody.velocity = moveDirection;
    }

    public void RotatePlayer(Vector3 moveDirection)
    {
        float angle = Mathf.Atan2(-moveDirection.z, moveDirection.x) * Mathf.Rad2Deg;

        if (moveDirection.magnitude > 0)
        {
            _lastRotation = Quaternion.Euler(0.0f, angle, 0.0f);
        }

        this._rigidbody.rotation = Quaternion.Slerp(this._rigidbody.rotation, _lastRotation, _rotationSpeed * Time.fixedDeltaTime);
    }

    private void StopPlayerMovement()
    {
        this._rigidbody.velocity = Vector3.zero;
    }

    private void PlaySound(String soundName)
    {
        RuntimeManager.PlayOneShotAttached(soundName, this.gameObject);
    }

    /// Set Animations
    private void SetAnimation(string animationName, bool value)
    {
        if (_playerAnimatorController.GetBool(animationName) != value)
        {
            _playerAnimatorController.SetBool(animationName, value);
        }
    }

    private void SetAnimation(string animationName, float value)
    {
        _playerAnimatorController.SetFloat(animationName, value);
    }

    // Set Dash Dictionary
    private void SetDashTypeDictionary()
    {
        _dashForces = new Dictionary<DashType, float>();

        foreach (DashTypeFloatPair dashFloatPair in _dashTypesList)
        {
            _dashForces.Add(dashFloatPair.DashType, dashFloatPair.Force);
        }
    }

    // Grounde Force Application

    private void ListenGrounder(bool IsGrounded) => this._isGrounded = IsGrounded;

    private void AddGrounderForce()
    {
        if (!_isGrounded && (_dashCoroutine == null))
        {
            _rigidbody.AddForce(new Vector3(0f, _forceToApplyVerticaly, 0f));
        }
    }

    /// Push Logic

    private void ApplyForce()
    {
        if (_curentForceToApply.magnitude > 0)
        {
            StopPlayerMovement();

            this._rigidbody.AddForce(_curentForceToApply);
        }
    }

    private void PushProcess(Collision collision, bool playsound = false)
    {
        IPushableObject pushableObject = collision.gameObject.GetComponent<IPushableObject>();
        if (pushableObject != null)
        {
            if (playsound)
            {
                PlaySound(_hitSound);
            }

            if (_dashCoroutine != null)
            {
                Push(collision, pushableObject);
                PushStun(true);
            }
        }
    }

    private void Push(Collision collision, IPushableObject objectToPush)
    {
        OnPush?.Invoke();
        SpawnStarEffect(collision.contacts);

        if (CheckBubblePowerUp(collision) == true)
        {
            collision.gameObject.GetComponent<PlayerController>()?.Invoke("OrderRemovePowerUp", 0f);

            this.PushObject(GetPushForceDirection(collision.gameObject.transform).normalized * _dashForces[_curentDashType] * -1, 
                this.GetComponent<IPushableObject>());
        }
        else
        {
            PlayerController player = collision.gameObject.GetComponent<PlayerController>();
            if (this._powerUp != null)
            {
                if (this._powerUp.Type == PowerUpTypes.Bomb)
                {
                    if (!player.HasPowerUp)
                    {
                        this.GivePowerUp(player);
                    }
                }
            }
            this.PushObject(GetPushForceDirection(collision.gameObject.transform).normalized * _dashForces[_curentDashType], objectToPush);
        }

        HaltDash();
    }

    private bool CheckBubblePowerUp(Collision collision)
    {
        PlayerController player = collision.gameObject.GetComponent<PlayerController>();
        if (player.HasPowerUp)
        {
            if (player.PowerUpType == PowerUpTypes.Bubble)
            {
                return true;
            }
        }

        return false;
    }

    private Vector3 GetPushForceDirection(Transform otherObjectPosition)
    {
        return new Vector3(otherObjectPosition.position.x, 0f, otherObjectPosition.position.z) - new Vector3(this.transform.position.x, 0f, this.transform.position.z);
    }

    private void SpawnStarEffect(ContactPoint[] contactPoints)
    {
        foreach (ContactPoint contact in contactPoints)
        {
            ObjectPooler.Instance.SpawnFromPool("Stars", contact.point, Quaternion.identity);
        }
    }

    private void ResetForceToAply() => _curentForceToApply = Vector3.zero;

    public void PushObject(Vector3 forceToApply, IPushableObject objectToPush)
    {
        objectToPush.AddForce(forceToApply);
    }

    public void AddForce(Vector3 forceToAdd)
    {
        this.SetAnimation("Dashing", false);
        this.SetAnimation("Charging", false);
        this._curentForceToApply += forceToAdd;
    }

    private void PushStun(bool isStuned)
    {
        if (isStuned != this._isStuned)
        {
            OnPushStun?.Invoke(isStuned);
        }

        this._isStuned = isStuned;
    }

    private void CheckPushStuned()
    {
        if (_isStuned)
        {
            if (this._rigidbody.velocity.magnitude <= _moveSpeed)
            {
                PushStun(false);
            }
        }
    }

    public void Drow()
    {
        if(this.HasPowerUp)
        {
            _powerUp.RemovePowerUp(this);
        }

        this.gameObject.SetActive(false);
    }

    // PowerUps

    public void AssociatePowerUp(PowerUp powerUp)
    {
        if (_powerUp == null)
        {
            _powerUp = powerUp;
        }
    }

    public void RemovePowerUpFromPlayer()
    {
        _powerUp = null;
    }

    public void OrderRemovePowerUp()
    {
        _powerUp.RemovePowerUp(this);
    }

    private void GivePowerUp(PlayerController otherPlayer)
    {
        this._powerUp.AssociatePlayer(otherPlayer);
        this._powerUp = null;
    }
}
