using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using Sirenix.OdinInspector;

public class PowerUpSpawner : MonoBehaviour
{
    [SerializeField] private PowerUp[] _powerUpTypes;
    [SerializeField] private float _timeBetweenSpawns = 10f;
    private float _timer = 0f;
    private GameObject _curentSpawnedPowerUp = null;
    [SerializeField] [Required] private CinemachineTargetGroup _cammeraTargetGroup;
    [SerializeField] private Transform[] _spawners;

    private void Start()
    {
        _timer = _timeBetweenSpawns;
        _curentSpawnedPowerUp = null;
    }

    private void Update()
    {
        if(_timer < 0f)
        {
            SpawnPowerUp();
            _timer = _timeBetweenSpawns;
        }
        else
        {
            _timer -= Time.deltaTime;
        }

        if (_curentSpawnedPowerUp != null)
        {
            if (!_curentSpawnedPowerUp.activeInHierarchy)
            {
                RemoveFromCammeraGroup();
            }
        }
    }

    private void SpawnPowerUp()
    {
        if (_curentSpawnedPowerUp == null)
        {
            _curentSpawnedPowerUp = _powerUpTypes[ChooseRandomPowerUp()].SpawnPowerUp(ChooseRandomSpawner());
            AssociateCammeraGroup();
        }
    }

    private int ChooseRandomPowerUp()
    {
        return Random.Range(0, _powerUpTypes.Length);
    }

    private Vector3 ChooseRandomSpawner()
    {
        return _spawners[Random.Range(0, _spawners.Length)].position;
    }

    private void AssociateCammeraGroup()
    {
        _cammeraTargetGroup.AddMember(_curentSpawnedPowerUp.transform, 1, 2.5f);
    }

    private void RemoveFromCammeraGroup()
    {
        _cammeraTargetGroup.RemoveMember(_curentSpawnedPowerUp.transform);
        _curentSpawnedPowerUp = null;
    }
}
