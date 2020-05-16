using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadNextGame : MonoBehaviour
{
    private static int _lastSceneIndex = -1;

    private void Start()
    {
        StartCoroutine(WaitForNextSceneToLoad());
    }

    private IEnumerator WaitForNextSceneToLoad()
    {
        int nextLevelIndex = ChooseNextScene();        

        AsyncOperation asyncLoadingOperation = SceneManager.LoadSceneAsync(nextLevelIndex);
        asyncLoadingOperation.allowSceneActivation = false;

        yield return new WaitForSeconds(5f);

        asyncLoadingOperation.allowSceneActivation = true;
    }

    private int ChooseNextScene()
    {
        int nextScene = Random.Range(1, 6);

        nextScene = CheckLastScene(nextScene);

        return nextScene;
    }
    
    private int CheckLastScene (int nextScene)
    {
        if (nextScene == _lastSceneIndex)
        {
            nextScene++;
        }

        if (nextScene >= 6)
        {
            nextScene = 1;
        }

        _lastSceneIndex = nextScene;

        return nextScene;
    }
}
