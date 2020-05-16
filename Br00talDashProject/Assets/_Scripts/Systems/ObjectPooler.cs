using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using UnityEngine.SceneManagement;
using System;

[System.Serializable]
public class Pool
{
    [HorizontalGroup("Non-Listed", width: 80)]
    [PreviewField(80, ObjectFieldAlignment.Left), HideLabel, AssetsOnly] 
    public GameObject prefab;


    [HorizontalGroup("Non-Listed")]
    [BoxGroup("Non-Listed/Properties", false)]
    public string tag;

    [HorizontalGroup("Non-Listed")]
    [BoxGroup("Non-Listed/Properties", false)]
    public int size;

    [HorizontalGroup("Non-Listed")]
    [BoxGroup("Non-Listed/Properties", false)]
    public bool fixSize;
}

public class ObjectPooler : MonoBehaviour
{
    #region Singleton
    public static ObjectPooler Instance = null;
    #endregion

    public List<Pool> pools;
    public Dictionary<string, Queue<GameObject>> poolDictionary;
    public Dictionary<string, GameObject> prefabDictionary;
    public Dictionary<string, bool> sizeDictionary;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
        else
        {
            Destroy(this.gameObject);
        }

        SceneManager.sceneLoaded += TurnOffEveryThing;
    }

    private void OnDestroy()
    {
        SceneManager.sceneLoaded -= TurnOffEveryThing;
    }

    void Start()
    {
        poolDictionary = new Dictionary<string, Queue<GameObject>>();
        prefabDictionary = new Dictionary<string, GameObject>();
        sizeDictionary = new Dictionary<string, bool>();

        foreach (Pool pool in pools)
        {
            Queue<GameObject> objectPool = new Queue<GameObject>();

            for (int i = 0; i < pool.size; i++)
            {
                GameObject obj = Instantiate(pool.prefab);
                obj.SetActive(false);
                DontDestroyOnLoad(obj);
                objectPool.Enqueue(obj);
            }

            poolDictionary.Add(pool.tag, objectPool);

            prefabDictionary.Add(pool.tag, pool.prefab);

            sizeDictionary.Add(pool.tag, pool.fixSize);
        }
    }

    public GameObject SpawnFromPool(string tag)
    {
        if (!KeyExists(tag))
        {
            return null;
        }

        GameObject objectToSpawn = Spawn(tag);

        IPooledObject pooledObj = objectToSpawn.GetComponent<IPooledObject>();

        if (pooledObj != null)
        {
            pooledObj.OnObjectSpawn();
        }
        else
        {
            Debug.LogError("Object does not contain Interface - " + tag, objectToSpawn);
        }

        poolDictionary[tag].Enqueue(objectToSpawn);

        return objectToSpawn;
    }

    public GameObject SpawnFromPool(string tag, Vector3 position, Quaternion rotation)
    {
        if(!KeyExists(tag))
        {
            return null;
        }

        GameObject objectToSpawn = Spawn(tag);

        objectToSpawn.transform.position = position;
        objectToSpawn.transform.rotation = rotation;

        IPooledObject pooledObj = objectToSpawn.GetComponent<IPooledObject>();

        if (pooledObj != null)
        {
            pooledObj.OnObjectSpawn();
        }
        else
        {
            Debug.LogError("Object does not contain Interface - " + tag, objectToSpawn);
        }

        poolDictionary[tag].Enqueue(objectToSpawn);

        return objectToSpawn;
    }

    public GameObject SpawnFromPool(string tag, Transform trans, bool parent = false)
    {
        if(!KeyExists(tag))
        {
            return null;
        }

        GameObject objectToSpawn = Spawn(tag);

        objectToSpawn.transform.position = trans.position;
        objectToSpawn.transform.rotation = trans.rotation;

        if (parent)
        {
            objectToSpawn.transform.parent = trans;
        }

        IPooledObject pooledObj = objectToSpawn.GetComponent<IPooledObject>();

        if (pooledObj != null)
        {
            pooledObj.OnObjectSpawn();
        }
        else
        {
            Debug.LogError("Object does not contain Interface - " + tag, objectToSpawn);
        }

        poolDictionary[tag].Enqueue(objectToSpawn);

        return objectToSpawn;
    }

    public bool KeyExists(string tag)
    {
        if (!poolDictionary.ContainsKey(tag))
        {
            Debug.LogError("Object pooler does not contain tag! - " + tag , this.gameObject);
            return false;
        }
        else
        {
            return true;
        }
    }

    private GameObject Spawn(string tag)
    {
        GameObject aux;
        
        if ((poolDictionary[tag].Count == 0 || poolDictionary[tag].Peek().activeInHierarchy) && !sizeDictionary[tag]) 
        {
            if (prefabDictionary.ContainsKey(tag))
            {
                aux = Instantiate(prefabDictionary[tag]);
                DontDestroyOnLoad(aux);

            }
            else
            {
                aux = null;
                Debug.LogError("Prefab Dictionary does not contain tag! - " + tag, this.gameObject);
            }
        }
        else
        {
            aux = poolDictionary[tag].Dequeue();
            aux.SetActive(true);
        }
        
        return aux;
    }

    private void TurnOffEveryThing(Scene arg0, LoadSceneMode arg1)
    {
        if (poolDictionary != null)
        {
            
        foreach (KeyValuePair<string, Queue<GameObject>> entry in poolDictionary)
        {
            for (int i = 0; i < entry.Value.Count; i++)
            {
                GameObject aux = entry.Value.Dequeue();
                aux.SetActive(false);
                aux.transform.parent = null;
                DontDestroyOnLoad(aux);
                entry.Value.Enqueue(aux);
            }
        }
        }
    }
}