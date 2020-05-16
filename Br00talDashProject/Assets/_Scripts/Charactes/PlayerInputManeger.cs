using Rewired;
using Sirenix.OdinInspector;
using System;
using UnityEngine;

[Flags] public enum Inputs
{
    Null = 0,
    Move = 1 << 0,
    Charge = 1 << 1,
    Dash = 1 << 2,
    Pause = 1 << 3
}

[RequireComponent(typeof(PlayerController))]
public class PlayerInputManeger : MonoBehaviour
{
    [SerializeField] [BoxGroup("Player Info")] private int _playerControllerIndex = 0;
    [SerializeField] [BoxGroup("Player Info")] private Player _playerController;
    public int PlayerId { get => _playerControllerIndex; } 

    [SerializeField] [BoxGroup("Controller Parameters")] private float _controllerDeadZone = 0.25f;

    public static Action OnPause;

    private Inputs _curentInputs = Inputs.Null;
    private PlayerController _playerControllerClass = null;
    private Grounder _playerGrounder = null;
    private bool _justStartedCharge = false;

    public Vector3 MoveDirection { get; private set; } = new Vector3();
    public float ChargeTime { get; private set; } = 0f;
    public bool IsCharging { get; private set; } = false;

    #region Lock Controller Parameters
    private bool _dashing = false;
    private bool _isGrounded = true;
    private bool _isPushStuned = false;
    #endregion

    private void Awake()
    {
        AssociatePlayer();
        GetEssentialComponentsComponent();
        SubscribeFunctions();
    }

    private void OnDestroy()
    {
        UnsubscribeFunctins();
    }

    void Update()
    {
        GetInputs();
        DecisionMaking();
    }

    /// Setup
    private void SubscribeFunctions ()
    {
        _playerControllerClass.OnDash += ListenDash;
        _playerGrounder.OnGrounded += ListenGrounder;
        _playerControllerClass.OnPushStun += ListenPushStun;
    }

    private void UnsubscribeFunctins()
    {
        _playerControllerClass.OnDash -= ListenDash;
        _playerGrounder.OnGrounded -= ListenGrounder;
        _playerControllerClass.OnPushStun -= ListenPushStun;
    }

    /// Controller Sethings
    private void AssociatePlayer()
    {
        _playerController = ReInput.players.GetPlayer(_playerControllerIndex);
    }

    public void ChangePlayer(int newPlayerIndex)
    {
        _playerControllerIndex = newPlayerIndex;
        _playerController = ReInput.players.GetPlayer(_playerControllerIndex);
    }

    private void GetEssentialComponentsComponent()
    {
        _playerControllerClass = this.GetComponent<PlayerController>();
        _playerGrounder = this.GetComponent<Grounder>();
    }

    /// Inputs
    private void GetInputs()
    {
        _curentInputs = Inputs.Null;

        GetMovement();
        GetCharge();
        GetDash();
        GetPause();
    }

    private void GetMovement()
    {
        MoveDirection = new Vector3(_playerController.GetAxisRaw("Horizontal"), 0, _playerController.GetAxisRaw("Vertical"));

        if (Mathf.Abs(MoveDirection.magnitude) >= _controllerDeadZone)
        {
            _curentInputs |= Inputs.Move;
        }
    }

    private void GetCharge()
    {
        _justStartedCharge = _playerController.GetButtonDown("Dash");

        if (_playerController.GetButton("Dash") || _justStartedCharge)
        {
            _curentInputs |= Inputs.Charge;

            ChargeTime = _playerController.GetButtonTimePressed("Dash");
        }
    }

    private void GetDash()
    {
        if (_playerController.GetButtonUp("Dash"))
        {
            _curentInputs |= Inputs.Dash;
        }
    }

    private void GetPause()
    {
        if (_playerController.GetButtonDown("Pause"))
        {
            _curentInputs |= Inputs.Pause;
        }
    }

    /// Decision Making
    private void DecisionMaking()
    {
        if ((_curentInputs & Inputs.Pause) == Inputs.Pause)
        {
            this.Pause();
        }
        else
        {
            if (!IsControllerLocked())
            {
                if ((_curentInputs & Inputs.Dash) == Inputs.Dash)
                {
                    this.Dash();
                }
                else
                {
                    this.Rotate();

                    if ((_curentInputs & Inputs.Charge) == Inputs.Charge)
                    {
                        this.Charge();
                    }
                    else if ((_curentInputs & Inputs.Move) == Inputs.Move)
                    {
                        this.Move();
                    }
                }
            }
        }
    }

    /// Calling Functions
    private void Pause()
    {
        OnPause?.Invoke();
    }

    private void Charge()
    {
        if (_playerControllerClass.CanCharge())
        {
            _playerControllerClass.Charge(_justStartedCharge);
            IsCharging = true;
        }
        else
        {
            IsCharging = false;
            _playerControllerClass.HaltCharge();
        }
    }

    private void Dash()
    {
        if (IsCharging)
        {
            _playerControllerClass.Dash(ChargeTime, MoveDirection);
        }
    }

    private void Move()
    {
        _playerControllerClass.MovePlayer(MoveDirection);
    }

    private void Rotate()
    {
        _playerControllerClass.RotatePlayer(MoveDirection);
    }

    // Controller LockDown

    private bool IsControllerLocked()
    {
        if (_dashing || !_isGrounded || _isPushStuned)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private void ListenDash(bool isDashing)
    {
        this._dashing = isDashing;
    }

    private void ListenGrounder(bool isGrounded)
    {
        this._isGrounded = isGrounded;
    }

    private void ListenPushStun(bool isPushStuned)
    {
        this._isPushStuned = isPushStuned;
    }
}
