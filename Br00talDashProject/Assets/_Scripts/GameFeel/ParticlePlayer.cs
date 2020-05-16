using UnityEngine;
using Sirenix.OdinInspector;

public class ParticlePlayer : MonoBehaviour, IPooledObject
{
    [SerializeField] private ParticleSystem _particleSystem;

    [SerializeField] private SubmitAudio _audio;

    public System.Action OnSpawn;

    private void Start()
    {
        GetParticleSystem();
        GetSoundSystem();
    }

    private void GetParticleSystem()
    {
        if (_particleSystem == null)
        {
            _particleSystem = this.GetComponentInChildren<ParticleSystem>();
        }
    }

    private void GetSoundSystem()
    {
        if (_audio == null)
        {
            _audio = this.GetComponentInChildren<SubmitAudio>();
        }
    }

    [Button]
    public void PlayParticleEffect()
    {
        _particleSystem.Play();
        PlayAudio();
    }

    public void PlayAudio()
    {
        _audio?.Emit();
    }

    public void OnObjectSpawn()
    {
        PlayParticleEffect();
        OnSpawn?.Invoke();
    }
}
