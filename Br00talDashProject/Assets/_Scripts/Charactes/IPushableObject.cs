using UnityEngine;

public interface IPushableObject
{
    void PushObject(Vector3 forceToApply, IPushableObject objectToPush);
    void AddForce(Vector3 forceToAdd);
    void Drow();
}