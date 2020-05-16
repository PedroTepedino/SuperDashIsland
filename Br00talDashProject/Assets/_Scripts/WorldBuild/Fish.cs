using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using Sirenix.OdinInspector;

public class Fish : MonoBehaviour, IPooledObject
{
    [SerializeField] private MaterialRandomizer _materialRandomizer;
    [SerializeField] private Rigidbody _rigidbody;
    [SerializeField] [BoxGroup("Force")] private Vector3 _maxForce = new Vector3(-2f, 5f, -2f);
    [SerializeField] [BoxGroup("Force")] private Vector3 _minForce = new Vector3(2f, 20f, 2f);
    [SerializeField] [BoxGroup("Time")] private float _secondsBeforeDespawn = 4f;
    [SerializeField] [BoxGroup("Scale")] private float _maxScale = 2f;
    [SerializeField] [BoxGroup("Scale")] private float _minScale = 1f;
    private Tween _tweenAnimation;
    private Rigidbody _body;

    private void Awake()
    {
        _body = this.GetComponent<Rigidbody>();
    }

    void IPooledObject.OnObjectSpawn()
    {
        this.transform.localScale = Vector3.zero;
        this.transform.DOScale(Random.Range(_minScale, _maxScale), 0.2f);
        _materialRandomizer.Randomize();
        RandomForce();
        Invoke("AnimateDespawn", _secondsBeforeDespawn);
    }

    private void RandomForce()
    {
        _rigidbody.velocity = new Vector3(Random.Range(_minForce.x, _maxForce.x), Random.Range(_minForce.y, _maxForce.y), Random.Range(_minForce.z, _maxForce.z));
    }

    private void AnimateDespawn()
    {
        _tweenAnimation = this.transform.DOScale(0.1f, 0.5f);
        _tweenAnimation.OnComplete(DespawnFish);
    }

    private void DespawnFish()
    {
        this.gameObject.SetActive(false);
    }

    private void OnBecameInvisible()
    {
        DespawnFish();
    }
}
