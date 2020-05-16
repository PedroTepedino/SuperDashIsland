using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class UiSliderObject : MonoBehaviour, IMoveHandler
{
    public int Value { get; private set; } = 0;

    [SerializeField] private List<GameObject> _objects;

    private void Start()
    {
        Value = 0;

        foreach (GameObject obj in _objects)
        {
            obj.SetActive(false);
        }

        _objects[Value].SetActive(true);
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

        int lastValue = Value;

        if (direction == MoveDirection.Right)
        {
            Value++;
        }
        else if (direction == MoveDirection.Left)
        {
            Value--;
        }

        if (Value < 0)
        {
            Value = _objects.Count - 1;
        }
        else if (Value >= _objects.Count)
        {
            Value = 0;
        }

        UpdateSlider(lastValue);
    }

    private void UpdateSlider(int LastValue)
    {
        _objects[LastValue].SetActive(false);
        _objects[Value].SetActive(true);
    }
}
