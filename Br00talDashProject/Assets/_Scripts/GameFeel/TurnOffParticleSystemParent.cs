using UnityEngine;

public class TurnOffParticleSystemParent : MonoBehaviour
{
    private void OnParticleSystemStopped()
    {
        this.transform.parent.gameObject.SetActive(false);
    }
}
