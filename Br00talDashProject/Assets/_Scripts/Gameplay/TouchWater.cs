////////////////////////////////////////////////////////
/// Actually applies to any liquid in the game hehe ///
///////////////////////////////////////////////////////
using UnityEngine;


public class TouchWater : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        Splash(collision.contacts);
        HandleObjectsOnWater(collision.gameObject);
    }

    private void HandleObjectsOnWater(GameObject objectOnWater)
    {
        IPushableObject objectToDrow = objectOnWater.GetComponent<IPushableObject>();
        if (objectToDrow != null)
        {
            Drow(objectToDrow);
        }
        else
        {
            HandleUndrowableObject(objectOnWater);
        }
    }

    private void Drow(IPushableObject objectToDrow)
    {
        objectToDrow.Drow();
    }

    private void HandleUndrowableObject(GameObject objectToDrow)
    {
        if (objectToDrow != null)
        {
            objectToDrow.SetActive(false);
        }
    }

    private void Splash(ContactPoint[] contactPointList)
    {
        foreach(ContactPoint contactPoint in contactPointList)
        {
            ObjectPooler.Instance.SpawnFromPool("Splash", contactPoint.point, Quaternion.identity);
        }
    }
}
