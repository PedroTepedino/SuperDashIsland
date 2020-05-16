using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;

public class SudoAi : MonoBehaviour
{
    [ShowInInspector] [ReadOnly] private bool Pause = false;
    [ShowInInspector] [ReadOnly] private Vector2 Movement;
    [ShowInInspector] [ReadOnly] private bool Dash = false;
    [ShowInInspector] [ReadOnly] private bool canDash = true;
    //[ShowInInspector] [ReadOnly] private PlayerController.DashType DashType = PlayerController.DashType.Null;

    //[SerializeField] private VirtualInput _input;

    [SerializeField] [Required] private List<Transform> _players;

    [SerializeField] [TabGroup("Dash")] private float _distanceForLongDash = 3f;

    private Transform _target = null;

    private void Start()
    {
        canDash = true;
        Dash = false;
    }

    private void Update()
    {
        ChooseTarget();
        DirectionProcess();
        DashProcess();

        UpdateValues();
    }


    private void UpdateValues()
    {
        //_input.Pause = this.Pause;
        //_input.Movement = this.Movement;
        //_input.Dash = this.Dash;
    }

    private void ChooseTarget()
    {
        _target = _players[0];

        for (int i = 0; i < _players.Count; i++)
        {
            if ((this.transform.position - _target.position).magnitude >= (this.transform.position - _players[i].transform.position).magnitude)
            {
                _target = _players[i];
            }
        }
    }

    private void DirectionProcess()
    {
        Movement = new Vector2((_target.position - this.transform.position).normalized.x, (_target.position - this.transform.position).normalized.z);
    }

    private void DashProcess()
    {
        if (!Dash && canDash)
        {
            if ((this.transform.position - _target.position).magnitude >= _distanceForLongDash)
            {
                StartCoroutine(DashTimer(0.7f));
                //DashType = PlayerController.DashType.Charged;
            }
            else
            {
                StartCoroutine(DashTimer(0.5f));
                //DashType = PlayerController.DashType.Standard;
            }
        }
    }

    private IEnumerator DashTimer(float time)
    {
        Dash = true;
        canDash = false;

        yield return new WaitForSeconds(time);

        Dash = false;

        StartCoroutine(UpdateDashStatus());
    }

    private IEnumerator UpdateDashStatus ()
    {
        yield return new WaitForSeconds(Random.Range(0.1f, 1.2f));
        canDash = true;
    }

    private void CleanList()
    {
        for (int i = 0; i < _players.Count; i++)
        {
            if (!_players[i].gameObject.activeInHierarchy)
            {
                _players.RemoveAt(i);
            }
        }
    }
}
