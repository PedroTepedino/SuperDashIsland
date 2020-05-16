using UnityEngine;
using DG.Tweening;


public class PropStep: MonoBehaviour
{
    private Tween _animation;

    private void Start()
    {
        InstantiateAnimation();
    }

    private void InstantiateAnimation()
    {
        _animation = this.transform.DOScaleY(0.1f, 0.2f).SetAutoKill(false);
        _animation.Rewind();
    }

    private void OnTriggerEnter(Collider other)
    {
        UnflipAnimation();
        _animation.Play();
    }

    private void OnTriggerExit(Collider other)
    {
        _animation.SmoothRewind();
    }

    private void UnflipAnimation()
    {
        if (_animation.isBackwards)
        {
            _animation.Flip();
        }
    }
}
