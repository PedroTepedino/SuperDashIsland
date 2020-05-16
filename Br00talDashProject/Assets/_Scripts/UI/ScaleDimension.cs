using UnityEngine;

[RequireComponent(typeof(RectTransform))]
public class ScaleDimension : MonoBehaviour
{
    private RectTransform _transform;

    private RectTransform _canvas;

    private const float A_CONST = 36.3086f;
    private const float B_CONST = -15832.0726f;

    private void Start()
    {
        _transform = this.GetComponent<RectTransform>();
        _canvas = this.GetComponentInParent<Canvas>().transform.GetComponent<RectTransform>();
    }

    private void Update()
    {
        float aux = ((A_CONST * _canvas.sizeDelta.y) + B_CONST) * _canvas.localScale.x;

        _transform.localScale = new Vector3(aux, aux, aux);
    }
}
