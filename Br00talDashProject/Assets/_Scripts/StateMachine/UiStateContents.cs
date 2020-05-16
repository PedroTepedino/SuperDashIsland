using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using System.Reflection;
using StateMachines.States;

[System.Serializable]
public class UiStateContents 
{
    [SerializeField] private GameObject _screenGameObject;
    [SerializeField] [EnumToggleButtons] private MainMenuStates _state;
    [SerializeField] [Required] private BaseState _stateScript;
    [SerializeField] private bool _hasDefaultButton;
    [SerializeField] [ShowIf("_hasDefaultButton")] private GameObject _defaultButton = null;
}
