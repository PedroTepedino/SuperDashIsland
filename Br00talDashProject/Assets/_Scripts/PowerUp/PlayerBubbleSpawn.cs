using UnityEngine;
using DG.Tweening;

public class PlayerBubbleSpawn : MonoBehaviour, IPooledObject
{
    public void OnObjectSpawn()
    {
        this.transform.DOScale(1f, 0.5f).From(0f);
    }

    private void OnDisable()
    {
        this.transform.parent = null;
        DontDestroyOnLoad(this.gameObject);
    }
}
