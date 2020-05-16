namespace StateMachines.States
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using UnityEngine.EventSystems;

    public class OptionsState : BaseState, IHasDefaultButton
    {
        private GameObject _defaultButton;
        public OptionsState(GameObject canvas) : base(canvas)
        {
            _defaultButton = null;
        }

        public override void EnterState()
        {
            this._canvasObject.SetActive(true);
            if (_defaultButton != null)
            {
                Debug.Log("Entrou");
                EventSystem.current.SetSelectedGameObject(_defaultButton);
            }
        }

        public override void ExitState()
        {
            //EventSystem.current.SetSelectedGameObject(null);
            this._canvasObject.SetActive(false);
        }

        public void SetButtonAsDefault(GameObject button)
        {
            _defaultButton = button;
        }

        public override MainMenuStates Tick()
        {
            MainMenuStates aux = this._nextState;
            this._nextState = MainMenuStates.Null;
            return aux;
        }
    }
}