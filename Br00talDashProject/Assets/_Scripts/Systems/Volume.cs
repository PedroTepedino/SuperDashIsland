using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Volume : MonoBehaviour
{
    FMOD.Studio.Bus Master;

    [SerializeField] private UiSlider _slider;

    private void Awake()
    {
        Master = FMODUnity.RuntimeManager.GetBus("bus:/Master");
        _slider.OnValueChange += ValueChange;

        if (PlayerPrefs.HasKey("VolumeMaster"))
        {
            _slider.SetState((int)PlayerPrefs.GetFloat("VolumeMaster"), 0, 100, 10);
        }
        else
        {
            _slider.SetState(100, 0, 100, 10);
            PlayerPrefs.SetFloat("VolumeMaster", 100f);
        }

        Master.setVolume(_slider.Value / 100f);
    }

    private void OnDestroy()
    {
        _slider.OnValueChange -= ValueChange;
    }

    private void OnEnable()
    {
        _slider.SetState((int)PlayerPrefs.GetFloat("VolumeMaster"), 0, 100, 10);
    }

    private void OnDisable()
    {
        PlayerPrefs.SetFloat("VolumeMaster", (float)_slider.Value);
    }

    private void ValueChange(int newValue)
    {
        Master.setVolume(_slider.Value / 100f);
    }
}
