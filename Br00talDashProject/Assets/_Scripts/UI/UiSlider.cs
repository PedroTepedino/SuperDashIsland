using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using TMPro;
using UnityEngine.UI;
using DG.Tweening;

[RequireComponent(typeof(Selectable))]
public class UiSlider : MonoBehaviour, IMoveHandler
{
    [SerializeField] private bool _loopAround = true;

    public int Value { get; private set; } = 0;

    [SerializeField] private int _min = 0;
    [SerializeField] private int _max = 10;
    [SerializeField] private int _increment = 1;

    private TextMeshProUGUI _text;

    public Action<int> OnValueChange;

    [SerializeField] private DOTweenAnimation _rightArrowAnimation;
    [SerializeField] private DOTweenAnimation _leftArrowAnimation;

    private void Start()
    {
        Value = 0;
        _text = this.GetComponentInChildren<TextMeshProUGUI>();
    }

    public void OnMove(AxisEventData eventData)
    {
        MoveProcess(eventData.moveDir);
    }

    private void MoveProcess(MoveDirection direction)
    {
        if (direction == MoveDirection.None)
        {
            return;
        }

        if (direction == MoveDirection.Right)
        {
            Value += _increment;
            _rightArrowAnimation.DORestart();
        }
        else if (direction == MoveDirection.Left)
        {
            Value -= _increment;
            _leftArrowAnimation.DORestart();
        }

        if (Value < _min)
        {
            if (!_loopAround)
            {
                Value = _min;
            }
            else
            {
                Value = _max - _min + Value + 1;
            }
        }
        else if (Value > _max)
        {
            if (!_loopAround)
            {
                Value = _max;
            }
            else
            {
                Value = _min - _max + Value - 1;
            }
        }

        UpdateSlider();

        // This function is Only called if the value has changed, thats why this is here.
        OnValueChange?.Invoke(Value);
    }

    private void UpdateSlider()
    {
        if (_text != null)
        {
            _text.text = Value.ToString();
        }
    }

    public void SetState(int value, int min, int max, int increment)
    {
        Value = value;
        _min = min;
        _max = max;
        _increment = increment;

        if (Value < _min || Value > _max)
        {
            Value = _min;
        }
    }
}
