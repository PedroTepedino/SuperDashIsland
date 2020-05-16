using UnityEngine;
using Sirenix.OdinInspector;

#region Power Up Types
public enum PowerUpTypes
{
    Null = 0,
    Meteore, 
    Bubble, 
    Bomb
}
#endregion

[CreateAssetMenu(fileName = "PowerUp", menuName = "Power Ups/PowerUp", order = 1)]
public class PowerUp : ScriptableObject
{
    [SerializeField] [LabelText("Game Object Prefab Tag")] protected string _gameObjectTag;

    [SerializeField] [LabelText("Effect To Spawn on Player")] protected string _effectTag;

    [SerializeField] [EnumToggleButtons] [LabelText("Type of Power Up")] protected PowerUpTypes _powerUpType;

    private GameObject _playerEffect = null;

    public PowerUpTypes Type { get => _powerUpType; }

    public virtual GameObject SpawnPowerUp(Vector3 position)
    {
        return ObjectPooler.Instance.SpawnFromPool(_gameObjectTag, position, Quaternion.identity);
    }

    public virtual void AssociatePlayer(PlayerController player)
    {
        player.AssociatePowerUp(this);
        if (_playerEffect == null)
        {
            _playerEffect = ObjectPooler.Instance.SpawnFromPool(this._effectTag, player.transform, parent: true);
        }
        else
        {
            _playerEffect.transform.parent = player.transform;
            _playerEffect.transform.position = player.transform.position;
        }
    }

    public virtual void Effect(PlayerController player)
    {
        throw new System.NotImplementedException();
    }

    public virtual void RemovePowerUp(PlayerController player)
    {
        _playerEffect.transform.parent = null;
        _playerEffect.SetActive(false);
        player.RemovePowerUpFromPlayer();
        _playerEffect = null;
    }
}
