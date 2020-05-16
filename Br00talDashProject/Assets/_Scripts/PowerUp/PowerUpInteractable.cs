using UnityEngine;
using Sirenix.OdinInspector;
using DG.Tweening;

[RequireComponent(typeof(Collider))]
public class PowerUpInteractable : MonoBehaviour, IPooledObject
{
    [SerializeField] [Required] private PowerUp _powerUpScriptableObject;

    private void OnTriggerEnter(Collider other)
    {
        PlayerController player = other.gameObject.GetComponent<PlayerController>();
        if (player != null)
        {
            AssociatePowerUp(player);
            DespawnObject();
        }
    }

    private void AssociatePowerUp(PlayerController player)
    {
        _powerUpScriptableObject.AssociatePlayer(player);
    }

    private void DespawnObject()
    {
        this.gameObject.SetActive(false);
    }

    public void OnObjectSpawn()
    {
        this.transform.DOScale(1f, 0.5f);
    }
}   
