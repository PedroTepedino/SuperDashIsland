using System.Collections.Generic;
using UnityEngine;
using StateMachines.States;
using StateMachines;
using System;
using UnityEngine.EventSystems;

[RequireComponent(typeof(StateMachine))]
public class UiStateMachineController : MonoBehaviour
{
    [SerializeField] private UiState[] _availableStates;

    [SerializeField] private List<UiStateContents> _test;

    private void Awake()
    {
        Dictionary<MainMenuStates, BaseState> dictionaryAuxiliar = new Dictionary<MainMenuStates, BaseState>();

        foreach(UiState uiState in _availableStates)
        {
            KeyValuePair<MainMenuStates, BaseState> keyValueAux = uiState.GetKeyValuePair();
            dictionaryAuxiliar.Add(key: keyValueAux.Key, value: keyValueAux.Value);
        }

        this.GetComponent<StateMachine>().SetStates(dictionaryAuxiliar);
    }

    private void Update()
    {
        Debug.Log(EventSystem.current.currentSelectedGameObject);
    }
}
