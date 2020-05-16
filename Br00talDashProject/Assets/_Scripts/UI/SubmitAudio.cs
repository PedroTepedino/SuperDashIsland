using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class SubmitAudio : MonoBehaviour
{
    [EventRef] [SerializeField] private string _event;

    public void Emit()
    {
        RuntimeManager.PlayOneShotAttached(_event, this.gameObject);
    }
}
