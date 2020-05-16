using UnityEngine;
using DG.Tweening;

public class BushInteraction : MonoBehaviour
{
    private DOTweenAnimation _animation;

    [SerializeField] private float _minimumTime = 0.7f;
    [SerializeField] private float _maximumTime = 1.0f;

    [SerializeField] private ParticlePlayer _plarticlePlayer;

    private void Start()
    {
        _animation = this.GetComponent<DOTweenAnimation>();
        _plarticlePlayer = this.GetComponentInChildren<ParticlePlayer>();
    }

    private void OnTriggerEnter(Collider other)
    {
        PlayAnimation();
        PlayParticleSystem();
    }

    private void PlayAnimation()
    {
        _animation.duration = Random.Range(_minimumTime, _maximumTime);

        _animation.DORestart();
    }

    private void PlayParticleSystem()
    {
        _plarticlePlayer?.Invoke("PlayParticleEffect", 0f);
    }
}
