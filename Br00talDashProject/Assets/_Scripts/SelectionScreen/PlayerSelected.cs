using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using Sirenix.OdinInspector;
using TMPro;

[System.Serializable] public enum ControllerType { controller = 0, Keyboard = 1, KeyboardLeft, KeyboardRight}

public class PlayerSelected : SerializedMonoBehaviour
{
    [SerializeField] private Image _backGround;
    [SerializeField] private Image _controller;

    [SerializeField] private TextMeshProUGUI _text;

    [SerializeField] private Dictionary<ControllerType, Sprite> _controllerTypes;

    private void OnEnable()
    {
        _text.DOFade(1f, 0.2f);
        _backGround.DOFade(0.3f, 0.2f);
        _controller.DOFade(0f, 0.2f);
        _controller.transform.DOScale(Vector3.zero, 0.2f);
    }

    public void PlayerAdded(int id)
    {
        _text.DOFade(0f, 0.2f);
        _backGround.DOFade(1f, 0.5f);
        _controller.DOFade(1f, 0.5f);
        _controller.transform.DOScale(Vector3.one, 0.2f);
        
        if (Rewired.ReInput.players.GetPlayer(id).controllers.hasKeyboard)
        {
            if (id == 4)
            {
                _controller.sprite = _controllerTypes[ControllerType.KeyboardLeft];
            }
            else if (id == 5)
            {
                _controller.sprite = _controllerTypes[ControllerType.KeyboardRight];
            }
            else
            {
                _controller.sprite = _controllerTypes[ControllerType.Keyboard];
            }
        }
        else
        {
            _controller.sprite = _controllerTypes[ControllerType.controller];
        }
    }

    public void PlayerRemoved()
    {
        _text.DOFade(1f, 0.2f);
        _backGround.DOFade(0.3f, 0.2f);
        _controller.DOFade(0f, 0.2f);
        _controller.transform.DOScale(Vector3.zero, 0.2f);
    }
}
