namespace StateMachines
{
    using System.Collections.Generic;
    using UnityEngine;
    using System.Linq;
    using System;
    using StateMachines.States;

    public class StateMachine : MonoBehaviour
    { 
        private Dictionary<MainMenuStates, BaseState> _availableStates;

        public BaseState CurentState { get; private set; }
        public BaseState PreviousState { get; private set; }

        public event Action<BaseState> OnStateChanged;

        public void SetStates(Dictionary<MainMenuStates, BaseState> states)
        {
            _availableStates = states;
        }

        private void Update()
        {
            if (CurentState == null)
            {
                CurentState = _availableStates.Values.First();
                CurentState.EnterState();
            }

            MainMenuStates nextState = CurentState.Tick();

            Debug.Log(CurentState);

            PreviousState = CurentState;

            if (nextState != MainMenuStates.Null && _availableStates[nextState]?.GetType() != CurentState?.GetType())
            {
                SwitchToNewState(nextState);
            }
        }

        private void SwitchToNewState(MainMenuStates nextState)
        {
            CurentState?.ExitState();

            CurentState = _availableStates[nextState];

            CurentState?.EnterState();

            OnStateChanged?.Invoke(CurentState);
        }

        public void SendNewStateToCurentState(int newState)
        {
            CurentState.ChangeState((MainMenuStates)(newState));
        }
    }
}