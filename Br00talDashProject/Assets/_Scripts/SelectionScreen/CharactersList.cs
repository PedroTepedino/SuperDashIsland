using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable] public struct PlayerInfo
{
    public int PlayerNumber { get; private set; }

    public string AnimalName { get; private set; }
    public int PlayerId { get; private set; }
    public GameObject Prefab { get; private set; }

    public PlayerInfo(int pNum, string name, int pId, GameObject pref)
    {
        this.PlayerNumber = pNum;
        this.AnimalName = name;
        this.PlayerId = pId;
        this.Prefab = pref;
    }
}

public static class CharactersList
{
    private static List<PlayerInfo> _playerIds = new List<PlayerInfo>();

    public static void AddPlayerInfo(int pnum, string name, int pId, GameObject pref)
    {
        if (_playerIds == null)
        {
            _playerIds = new List<PlayerInfo>();
        }

        if (pref != null)
        {
            _playerIds.Add(new PlayerInfo(pnum, name, pId, pref));
        }
    }

    public static void RemovePlayer(int pnum)
    {
        for (int i = 0; i < _playerIds.Count; i++)
        {
            if (_playerIds[i].PlayerNumber == pnum)
            {
                _playerIds.RemoveAt(i);
                return;
            }
        }
    }

    public static bool CheckPlayer(int pId)
    {
        for (int i = 0; i < _playerIds.Count; i++)
        {
            if (_playerIds[i].PlayerId == pId)
            {
                return true;
            }
        }

        return false;
    }

    public static int NextPlayer()
    {
        int aux = 0;

        if (_playerIds.Count >= 4)
        {
            return -1;
        }

        for (int i = 0; i < _playerIds.Count; i++)
        {
            if (_playerIds[i].PlayerNumber == aux)
            {
                aux++;
                i = 0;
            }
        } // Arrumar isso depois

        return aux;
    }

    public static PlayerInfo GetPlayer(int id)
    {
        for (int i = 0; i < _playerIds.Count; i++)
        {
            if (_playerIds[i].PlayerId == id)
            {
                return _playerIds[i];
            }
        }

        return new PlayerInfo(-2, null, -2, null); // Padronizar isso for reals
    }

    public static PlayerInfo GetInfo(int i)
    {
        return _playerIds[i];
    }

    public static int PlayerCount { get => _playerIds.Count; }

    public static void ClearList()
    {
        _playerIds = null;
        _playerIds = new List<PlayerInfo>();
    }

    public static void PrintNames()
    {
        string aux = null;

        for (int i = 0; i < _playerIds.Count; i++)
        {
            aux += _playerIds[i].AnimalName + "  ";
        }

        Debug.Log(aux);
    }
}
