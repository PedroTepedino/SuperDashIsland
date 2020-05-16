using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class ToggleFullScreen : MonoBehaviour
{
    private void Awake()
    {
        if (PlayerPrefs.HasKey("FullScreen"))
        {
            SetFullScreen(PlayerPrefs.GetInt("FullScreen") > 0);
        }
        else
        {
            SetFullScreen(true);
            PlayerPrefs.SetInt("FullScreen", 1);
        }
    }

    private void OnEnable()
    {
        this.GetComponent<Toggle>().isOn = Screen.fullScreen;
    }

    private void OnDisable()
    {
        PlayerPrefs.SetInt("FullScreen", Screen.fullScreen ? 1 : 0);
    }

    public void SetFullScreen(bool fullScreenState)
    {
        Screen.fullScreen = fullScreenState;
    }
}
