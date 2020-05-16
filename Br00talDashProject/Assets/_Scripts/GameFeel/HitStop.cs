using System.Collections;
using UnityEngine;
using System;

public class HitStop : MonoBehaviour
{
    [SerializeField] private bool _enabled = true;

    private static bool _wating;

    [SerializeField] private float _time = 0.05f; 

    public static Action<bool> OnHitStop;

    private void Awake()
    {
        PlayerController.OnPush += Stop;   
    }

    private void OnDestroy()
    {
        PlayerController.OnPush -= Stop;
    }

    public void Stop()
    {
        if (_enabled)
        {
            if (!_wating)
            {
                OnHitStop?.Invoke(true);
                Time.timeScale = 0f;
                StartCoroutine(WaitStopEnd(_time));
            } 
        }
    }

    private IEnumerator WaitStopEnd(float time)
    {
        _wating = true;

        yield return new WaitForSecondsRealtime(time);

        Time.timeScale = 1.0f;

        _wating = false;
        OnHitStop?.Invoke(false);
    }
}
