using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Version(1, 0, 0)]
[Title("Save and Load Scene by Layers")]
[Description("Saves and loads GameObjects in the scene based on specified layers")]
[Category("Custom/Save and Load Scene by Layers")]
[Parameter("Save File Name", "Name of the file where the scene will be saved")]
[Parameter("Layers to Save", "LayerMask determining which objects to save and load")]
[Parameter("Trigger Save", "Boolean to trigger saving the scene")]
[Parameter("Trigger Load", "Boolean to trigger loading the scene")]
[Keywords("Save", "Load", "Scene", "Layers", "GameObjects")]
[Serializable]
public class InstructionSaveLoadSceneByLayers : Instruction
{
    [SerializeField] private string saveFileName = "savedScene.json";
    [SerializeField] private LayerMask layersToSave;
    [SerializeField] private bool triggerSave = false;
    [SerializeField] private bool triggerLoad = false;

    [System.Serializable]
    public class GameObjectData
    {
        public string name;
        public Vector3 position;
        public Quaternion rotation;
        public Vector3 scale;
    }

    public override string Title => $"Save/Load Scene by Layers to/from {saveFileName}";

    protected override async Task Run(Args args)
    {
        if (triggerSave) SaveScene();
        if (triggerLoad) LoadScene();
        await DefaultResult;
    }

    private void SaveScene()
    {
        List<GameObjectData> sceneData = new List<GameObjectData>();

        foreach (GameObject go in UnityEngine.Object.FindObjectsOfType<GameObject>())
        {
            if (!IsInLayer(go)) continue;

            GameObjectData data = new GameObjectData
            {
                name = go.name,
                position = go.transform.position,
                rotation = go.transform.rotation,
                scale = go.transform.localScale
            };

            sceneData.Add(data);
        }

        string json = JsonUtility.ToJson(new { objects = sceneData }, true);
        File.WriteAllText(saveFileName, json);
        Debug.Log("Scene saved to " + saveFileName);
    }

    private void LoadScene()
    {
        if (!File.Exists(saveFileName))
        {
            Debug.LogError("Save file not found.");
            return;
        }

        string json = File.ReadAllText(saveFileName);
        var sceneData = JsonUtility.FromJson<List<GameObjectData>>(json);

        foreach (var data in sceneData)
        {
            GameObject newGO = new GameObject(data.name);
            newGO.transform.position = data.position;
            newGO.transform.rotation = data.rotation;
            newGO.transform.localScale = data.scale;
        }

        Debug.Log("Scene loaded from " + saveFileName);
    }

    private bool IsInLayer(GameObject go)
    {
        return (layersToSave.value & (1 << go.layer)) != 0;
    }
}


