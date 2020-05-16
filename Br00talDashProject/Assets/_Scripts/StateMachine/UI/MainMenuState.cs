namespace StateMachines.States
{
    using System;
    using UnityEngine;
    using UnityEngine.EventSystems;

    public class MainMenuState : BaseState, IHasDefaultButton
    {
        private GameObject _defaultButton;
        public MainMenuState (GameObject canvas) : base(canvas)
        {
            _defaultButton = null;
        }

        public override void EnterState()
        {
            this._canvasObject.SetActive(true);
            Debug.Log("Default Button For MainMenu : " + _defaultButton);

            if (_defaultButton != null)
            {
                Debug.Log("Entrou!!");
                EventSystem.current.SetSelectedGameObject(_defaultButton);
            }
        }

        public override void ExitState()
        {
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
