using UnityEngine;
using Sirenix.OdinInspector;

public class Grounder : MonoBehaviour
{
    [FoldoutGroup("Paremeters")] [SerializeField] private Vector3 _groundeCenter = Vector3.zero;
    [FoldoutGroup("Paremeters")] [SerializeField] private Vector3 _grounderHalfExtents;
    [FoldoutGroup("Paremeters")] [SerializeField] [EnumToggleButtons] private LayerMask _grounderLayerMask;

    public bool IsGrounded { get; private set; } = false;

    public System.Action<bool> OnGrounded;

    private void Update()
    {
        bool auxiliarIsGrounded = GroundCheck();

        if (auxiliarIsGrounded != IsGrounded)
        {
            IsGrounded = auxiliarIsGrounded;
            OnGrounded?.Invoke(IsGrounded);
        }
    }

    private bool GroundCheck()
    {
        return Physics.CheckBox(this.transform.position + _groundeCenter, _grounderHalfExtents, Quaternion.identity, _grounderLayerMask);
    }

    protected void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(this.transform.position + _groundeCenter, _grounderHalfExtents * 2f);
    }
}
