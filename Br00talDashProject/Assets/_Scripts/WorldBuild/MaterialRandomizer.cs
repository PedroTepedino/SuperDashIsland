using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class MaterialRandomizer : MonoBehaviour
{
    [SerializeField] [ToggleLeft] private bool _randomizeMaterial = true;

    [SerializeField] private MeshRenderer _renderer = null;

    [SerializeField] [PreviewField(ObjectFieldAlignment.Left)] private List<Material> _materials;

    private void Awake()
    {
        GetEssecialMonoBehaviours();
    }

    private void GetEssecialMonoBehaviours()
    {
        if (_renderer == null)
        {
            _renderer = this.GetComponentInChildren<MeshRenderer>();
        }
    }

    private void Start()
    {
        if (_randomizeMaterial)
        {
            Randomize();
        }
    }

    [ExecuteAlways] [Button]
    public void Randomize()
    {
        int aux = Random.Range(0, _materials.Count);

        _renderer.material = _materials[aux];
    }
}
