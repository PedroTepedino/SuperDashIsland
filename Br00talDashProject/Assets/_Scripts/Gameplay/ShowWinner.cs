using UnityEngine;
using DG.Tweening;

public class ShowWinner : MonoBehaviour
{
    [SerializeField] private DOTweenAnimation _textAnimation;

    [SerializeField] private GameObject _winerScreen;

    private void Awake()
    {
        GameStart.OnWinner += ShowWiner;
    }

    private void OnDestroy()
    {
        GameStart.OnWinner -= ShowWiner;
    }

    private void ShowWiner(string animalName)
    {
        ChangeTextToWinersName(animalName);
        _winerScreen.SetActive(true);
    }

    private void ChangeTextToWinersName(string winerName)
    {
        if (winerName == null)
        {
            _textAnimation.endValueString = "It's a <size=150%>DRAW<size=100%> !?!?!?!?!?";
        }
        else
        {
            _textAnimation.endValueString = "Mr. <size=150%>" + winerName + "<size=100%> Wins !!!!!";
        }
    }
}
