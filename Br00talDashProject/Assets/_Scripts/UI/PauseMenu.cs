using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using Rewired;

public class PauseMenu : MonoBehaviour
{
    [SerializeField] private GameObject _resume;

    [SerializeField] private GameObject _pauseScene;

    private void Awake()
    {
        Time.timeScale = 1f;
        PlayerInputManeger.OnPause += Pause;
    }

    private void OnDestroy()
    {
        Time.timeScale = 1f;
        PlayerInputManeger.OnPause -= Pause;
    }

    private void Start()
    {
        _pauseScene.SetActive(false);
        Time.timeScale = 1f;
    }

    private void Pause()
    {
        if (!_pauseScene.activeInHierarchy)
        {
            Time.timeScale = 0f;
            _pauseScene.SetActive(true);
            EventSystem.current.SetSelectedGameObject(_resume);
        }
        else
        {
            UnPause();
        }
    }

    public void UnPause()
    {
        Time.timeScale = 1f;
        _pauseScene.SetActive(false);
    }

    private void OnDisable()
    {
        Time.timeScale = 1f;
    }

    public void ReturnToMenu()
    {
        Time.timeScale = 1f;
        SceneManager.LoadScene(0);
    }

    private void Update()
    {
        if (_pauseScene.activeInHierarchy)
        {
            if (EventSystem.current.currentSelectedGameObject == null)
            {
                EventSystem.current.SetSelectedGameObject(_resume);
            }
        }
    }
}
