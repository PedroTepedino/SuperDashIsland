using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicConsistency : MonoBehaviour
{
    private static MusicConsistency _instance = null;

    private void Awake()
    {
        if (_instance == null)
        {
            _instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
        else
        {
            Destroy(this.gameObject);
        }
    }
}

