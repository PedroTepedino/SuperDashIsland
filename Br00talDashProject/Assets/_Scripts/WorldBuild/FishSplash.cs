using UnityEngine;
using Sirenix.OdinInspector;

[RequireComponent(typeof(ParticlePlayer))]
public class FishSplash : MonoBehaviour
{
    private void Awake()
    {
        this.GetComponent<ParticlePlayer>().OnSpawn += SpawnFish;
    }

    private void OnDestroy()
    {
        this.GetComponent<ParticlePlayer>().OnSpawn -= SpawnFish;
    }

    [Button]
    private void SpawnFish()
    {
        for (int i = 0; i <= Random.Range(5, 10); i++)
        {
            ObjectPooler.Instance.SpawnFromPool("Fish", this.transform);
        }
    }
}
