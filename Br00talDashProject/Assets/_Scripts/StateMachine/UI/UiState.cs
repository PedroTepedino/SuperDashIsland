namespace StateMachines
{
    using System.Collections.Generic;
    using UnityEngine;
    using Sirenix.OdinInspector;
    using System.Reflection;
    using StateMachines.States;

    [CreateAssetMenu(fileName = "UiState", menuName = "States/UiState", order = 1)]
    public class UiState : SerializedScriptableObject
    {
        [SerializeField] private GameObject _screenGameObject;
        [SerializeField] [EnumToggleButtons] private MainMenuStates _state;
        [SerializeField] [Required] private BaseState _stateScript;
        [SerializeField] private bool _hasDefaultButton;
        [SerializeField] [ShowIf("_hasDefaultButton")] private GameObject _defaultButton = null;

        //[SerializeField]
        //[Required]
        //[ValidateInput("@typeof(BaseState).IsAssignableFrom(_stateType)", "Type needs to derive from BaseState", InfoMessageType.Error)]
        //private System.Type _stateType;

        public KeyValuePair<MainMenuStates, BaseState> GetKeyValuePair()
        {
            System.Type stateType = _stateScript.GetType();
            ConstructorInfo stateConstructorInfo = stateType.GetConstructor(new[] { typeof(GameObject) });
            BaseState stateObject = stateConstructorInfo.Invoke(new object[] { _screenGameObject }) as BaseState;

            if (_hasDefaultButton && stateObject is IHasDefaultButton)
            {
                (stateObject as IHasDefaultButton).SetButtonAsDefault(_defaultButton);
            }

            return new KeyValuePair<MainMenuStates, BaseState>(_state, stateObject);
        }
    }
}
