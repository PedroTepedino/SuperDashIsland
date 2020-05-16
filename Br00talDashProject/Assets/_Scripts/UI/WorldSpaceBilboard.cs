using UnityEngine;

[ExecuteAlways]
[RequireComponent(typeof(Canvas))]
public class WorldSpaceBilboard : MonoBehaviour
{
    private Transform _mainCam;

    private void Start() 
    {
        this.GetComponent<Canvas>().worldCamera = Camera.main;
        _mainCam = Camera.main.transform;
    }

    private void OnEnable()
    {
        this.GetComponent<Canvas>().worldCamera = Camera.main;
        _mainCam = Camera.main.transform;
    }

    private void Update() 
    {
        this.transform.rotation = _mainCam.rotation;
    }
}
