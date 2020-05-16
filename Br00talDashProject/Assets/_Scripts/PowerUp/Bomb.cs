using UnityEngine;
using Sirenix.OdinInspector;
using TMPro;

public class Bomb : MonoBehaviour, IPooledObject
{
    [SerializeField] [BoxGroup("Time")] private float _timeToExplode = 5f;
    [ShowInInspector] [BoxGroup("Time")] private float _timer = 0f;

    [SerializeField] [BoxGroup("Explosion")] private float _explosionRadius = 10f;
    [SerializeField] [BoxGroup("Explosion")] private float _explosionForce = 1000f;
    [SerializeField] [BoxGroup("Explosion")] private LayerMask _explosionMask;
    [SerializeField] [BoxGroup("Explosion")] private string _explosionEffectTag;

    [SerializeField] [BoxGroup("External")] [Required] private TextMeshProUGUI _text;

    public void OnObjectSpawn()
    {
        _timer = _timeToExplode;
    }

    private void Update()
    {
        ExplosionLogic();
        ShowTextTime();
    }

    private void ExplosionLogic()
    {
        if (_timer >= 0f)
        {
            _timer -= Time.deltaTime;
        }
        else
        {
            ExplosionProcess();
        }
    }

    private void ExplosionProcess()
    {
        Collider[] colliders = Physics.OverlapSphere(this.transform.position, _explosionRadius, _explosionMask);
        foreach (Collider  collider in colliders)
        {
            if (collider.gameObject != this.transform.parent.gameObject)
            {
                collider.gameObject.GetComponent<Rigidbody>().AddExplosionForce(_explosionForce, this.transform.position, _explosionRadius);
            }
        }

        ObjectPooler.Instance.SpawnFromPool(_explosionEffectTag, this.transform);
        StartCoroutine(DisableObject());
    }

    private System.Collections.IEnumerator DisableObject()
    {
        IPushableObject player = this.GetComponentInParent<IPushableObject>();
        
        yield return new WaitForEndOfFrame();

        this.GetComponentInParent<PlayerController>().OrderRemovePowerUp();
        player.Drow();
    }

    private void ShowTextTime()
    {
        _text.text = Mathf.CeilToInt(_timer).ToString();
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(this.transform.position, _explosionRadius);
    }

    private void OnDisable()
    {
        this.transform.parent = null;
        DontDestroyOnLoad(this.gameObject);
    }
}
