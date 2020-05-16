using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(ParticleSystem))]
public class MeteorEffect : MonoBehaviour, IPooledObject
{
    private ParticleSystem _particleSystem;

    private void Awake()
    {
        _particleSystem = this.GetComponent<ParticleSystem>();
    }

    public void OnObjectSpawn()
    {
        _particleSystem.Play();
    }

    private void OnDisable()
    {
        this.transform.parent = null;
        DontDestroyOnLoad(this.gameObject);
    }
}
