using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Rewired;
using Sirenix.OdinInspector;
using TMPro;
using UnityEngine.SceneManagement;
using FMODUnity;
using DG.Tweening;

[Serializable] public struct ModelPrefabPair
{
    [SerializeField] [VerticalGroup] public string Name;
    [SerializeField] [VerticalGroup] [HideLabel] public GameObject Model;
    [SerializeField] [PreviewField(Alignment = ObjectFieldAlignment.Left)] [VerticalGroup] [HideLabel] public GameObject Prefab;
}

public class SelectionScreen : MonoBehaviour
{
    [SerializeField] private List<ModelPrefabPair> _originalList;
    private List<ModelPrefabPair> _modelPrefabList;

    [SerializeField] private GameObject[] _playerUis;

    [SerializeField] private TextMeshProUGUI _timerText;

    [SerializeField] private GameObject _mainMenu;

    [SerializeField] private TextMeshProUGUI _startinstruction;

    [EventRef] [SerializeField] private string _submitEvent;

    private void OnEnable()
    {
        _modelPrefabList = new List<ModelPrefabPair>(_originalList) ;
        CharactersList.ClearList();
    }

    private void Update()
    {
        foreach (Player p in ReInput.players.AllPlayers)
        {
            if (p.GetButtonDown("UISubmit"))
            {
                AddPlayer(p.id);
                RuntimeManager.PlayOneShot(_submitEvent);
            }
            else if (p.GetButtonDown("UICancel"))
            {
                RuntimeManager.PlayOneShot(_submitEvent);
                if (!RemovePlayer(p.id))
                {
                    ReturnToMainMenu();
                }
            }
        }
    }

    private ModelPrefabPair RandomCharacter()
    {
        int aux = UnityEngine.Random.Range(0, _modelPrefabList.Count);
        var model = _modelPrefabList[aux];
        _modelPrefabList.RemoveAt(aux);
        return model;
    }

    private void AddPlayer(int id)
    {
        if (!CharactersList.CheckPlayer(id))
        {
            int playerNum = CharactersList.NextPlayer();
            var aux = RandomCharacter();

            CharactersList.AddPlayerInfo(playerNum, aux.Name, id, aux.Prefab);

            var model = aux.Model;
            model.transform.parent = _playerUis[playerNum].transform;
            model.GetComponent<RectTransform>().anchoredPosition = Vector2.zero;
            model.SetActive(true);

            _playerUis[playerNum].GetComponent<PlayerSelected>().PlayerAdded(id);
        }
    }

    private bool RemovePlayer(int Id)
    {
        PlayerInfo pInfo = CharactersList.GetPlayer(Id);

        if (pInfo.PlayerNumber < 0)
        {
            return false;
        }

        if (pInfo.PlayerNumber >= 0)
        {
            CharactersList.RemovePlayer(pInfo.PlayerNumber);

            ModelPrefabPair aux = new ModelPrefabPair();

            aux.Prefab = pInfo.Prefab;
            aux.Name = pInfo.AnimalName;

            aux.Model = _playerUis[pInfo.PlayerNumber].GetComponentInChildren<ScaleDimension>().gameObject;
            _playerUis[pInfo.PlayerNumber].GetComponent<PlayerSelected>().PlayerRemoved();
            aux.Model.SetActive(false);
            aux.Model.transform.parent = this.transform;

            _modelPrefabList.Add(aux);
        }
        else
        {
            return false;
        }

        return true;
    }

    private void FixedUpdate()
    {
        if (CharactersList.PlayerCount >= 2)
        {
            _startinstruction.DOFade(1, 0.5f).SetEase(Ease.OutQuad);
            foreach (Player p in ReInput.players.AllPlayers)
            {
                if (p.GetButton("StartGame"))
                {
                    SceneManager.LoadScene(6);
                }
            }
        }
        else
        {
            _startinstruction.DOFade(0, 0.2f).SetEase(Ease.OutQuad);
        }
    }

    private void ReturnToMainMenu()
    {
        _mainMenu.SetActive(true);

        foreach(ModelPrefabPair p in _originalList)
        {
            p.Model.SetActive(false);
            p.Model.transform.parent = this.transform;
        }

        this.gameObject.SetActive(false);
    }
}
