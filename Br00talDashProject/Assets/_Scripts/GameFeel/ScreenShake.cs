using System.Collections;
using UnityEngine;
using Cinemachine;
using Sirenix.OdinInspector;

//This code need to execute after the cinemachine Brain !!!!!!!!!!
//e aparentemente essa porra nao consegue achar a camera de jeito nenhum
//Tem q associar a camera de qq jeito.

public class ScreenShake : MonoBehaviour
{
    [SerializeField] private bool _enabled = true;

    [SerializeField] [TabGroup("Iddle")] private float _iddleAmplitude = 0f;
    [SerializeField] [TabGroup("Iddle")] private float _iddleFrequency = 0f;

    [SerializeField] [TabGroup("Shake")] private float _shakeTime = 0.1f;
    [SerializeField] [TabGroup("Shake")] private float _amplitudeGain = 6.0f;
    [SerializeField] [TabGroup("Shake")] private float _frequencyGain = 0.05f;

    [SerializeField] [Required] [TabGroup("Camera")] private CinemachineVirtualCamera _virtualCamera;
    [ShowInInspector] [ReadOnly] [TabGroup("Camera")] private CinemachineBasicMultiChannelPerlin _virtualCameraNoise;

    private void Awake()
    {
        GetCameraNoise();

        PlayerController.OnPush += Shake;
    }

    private void OnDestroy()
    {
        PlayerController.OnPush -= Shake;
    }

    private void Start()
    {
        ResetCamera();
    }

    private void GetCameraNoise()
    {
        _virtualCameraNoise = _virtualCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
    }

    private void ResetCamera()
    {
        _virtualCameraNoise.m_AmplitudeGain = _iddleAmplitude;
        _virtualCameraNoise.m_FrequencyGain = _iddleFrequency;
    }

    public void Shake()
    {
        if (_enabled)
        {
            StartCoroutine(WaitForShakeToEnd(_shakeTime, _amplitudeGain, _frequencyGain));
        }
    }

    private IEnumerator WaitForShakeToEnd(float shakeTime, float amplitude, float frequency)
    {
        _virtualCameraNoise.m_AmplitudeGain = amplitude;
        _virtualCameraNoise.m_FrequencyGain = frequency;

        yield return new WaitForSeconds(shakeTime);

        ResetCamera();
    }
}
