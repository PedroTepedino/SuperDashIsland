using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using UnityEngine.SceneManagement;
using FMODUnity;

public class GameStart : MonoBehaviour
{
    [SerializeField] private Transform[] _spawns;
    [SerializeField] private CinemachineTargetGroup _targetGroup;

    private List<GameObject> _players;

    [SerializeField] [EventRef] private string _winSound;

    // Default Camera
    [SerializeField] private float _spawnTargetGroupRadius = 1;

    // Winner
    private GameObject _winner = null;
    public static System.Action<string> OnWinner;
    private bool _gameOver = false;
    private float _waitTimeForWinCheck = 0.5f;

    private void Start()
    {
        _gameOver = false;

        _players = new List<GameObject>();

        Debug.Log(CharactersList.PlayerCount);

        for (int i = 0; i < CharactersList.PlayerCount; i++)
        {
            PlayerInfo info = CharactersList.GetInfo(i);
            GameObject aux = GameObject.Instantiate(info.Prefab);

            aux.GetComponent<PlayerInputManeger>().ChangePlayer(info.PlayerId);
            aux.transform.position = _spawns[i].position;

            _targetGroup.AddMember(aux.transform, 1, 2.5f);
            _players.Add(aux);
        }

        foreach(Transform spawn in _spawns)
        {
            _targetGroup.RemoveMember(spawn);
        }

        _winner = null;
    }

    private void Update()
    {

        int counter = 0;

        foreach(GameObject g in _players)
        {
            if (g.activeInHierarchy)
            {
                counter++;
            }
        }

        if (counter <= 1 && !_gameOver)
        {
            _gameOver = true;
            StartCoroutine(WinWaitTime(_waitTimeForWinCheck));
        }
    }

    private IEnumerator WinWaitTime(float time)
    {
        yield return new WaitForSeconds(time);

        Win(GetWinner());
    }

    private GameObject GetWinner()
    {
        GameObject aux = null;
        foreach (GameObject g in _players)
        {
            if (g.activeInHierarchy)
            {
                aux = g;
            }
        }
        return aux;
    }

    private void LateUpdate()
    {
        foreach(GameObject g in _players)
        {
            if (!g.activeInHierarchy)
            {
                _targetGroup.RemoveMember(g.transform);
            }
        }

        if (_targetGroup.IsEmpty)
        {
            AssociateSpawnsToTargetGroup();
        }
    }

    private void Win(GameObject winner)
    {
        _winner = winner;

        OnWinner?.Invoke(GetWinnerName());

        RuntimeManager.PlayOneShot(_winSound);

        StartCoroutine(WaitASec());
    }

    private IEnumerator WaitASec()
    {
        yield return new WaitForSeconds(4f);

        LoadTutorial();
    }

    private void AssociateSpawnsToTargetGroup()
    {
        foreach(Transform spawn in _spawns)
        {
            _targetGroup.AddMember(spawn, 1f, _spawnTargetGroupRadius);
        }
    }

    private void LoadTutorial()
    {
        SceneManager.LoadScene(6);
    }

    private string GetWinnerName()
    {
        if (_winner == null) 
        {
            return null;
        }
        else
        {
            return CharactersList.GetPlayer(_winner.GetComponent<PlayerInputManeger>().PlayerId).AnimalName;
        }
    }
}
