namespace StateMachines.States
{
    using System.Collections;
    using System.Collections.Generic;
    using UnityEngine;
    using System;

    public abstract class BaseState
    {
        protected GameObject _canvasObject;

        protected MainMenuStates _nextState;

        public BaseState(GameObject canvas)
        {
            _canvasObject = canvas;
            _nextState = MainMenuStates.Null;
        }

        public abstract void EnterState();
        public abstract void ExitState();

        public abstract MainMenuStates Tick();
 
        public virtual void ChangeState(MainMenuStates nextState) 
        {
            this._nextState = nextState;
        }

        public static Type GetStateType<T>(T state) where T : Enum
        {
            T[] allStates = Enum.GetValues(typeof(T)) as T[];

            for (int i = 0; i < allStates.Length; i++)
            {
                if (state.CompareTo(allStates[i]) != 0)
                {
                    return Type.GetType(typeof(BaseState).Namespace 
                                 + "." + allStates[i].ToString(),
                                     throwOnError: false);
                }
            }

            return null;
        }

        public static Type[] GetStateTypeFlags<T>(T state) where T : Enum
        {
            List<Type> aux = new List<Type>();

            T[] allStates = Enum.GetValues(typeof(T)) as T[];

            for (int i = 0; i < allStates.Length; i++)
            {
                if (state.CompareTo(allStates[i]) != 0)
                {
                    aux.Add(Type.GetType(typeof(BaseState).Namespace
                        + "." + allStates[i].ToString(),
                            throwOnError: false));
                }
            }

            return aux.ToArray();
        }
    }
}