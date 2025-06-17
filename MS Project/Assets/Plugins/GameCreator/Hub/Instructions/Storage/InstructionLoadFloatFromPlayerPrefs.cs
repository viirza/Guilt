using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Load Float From PlayerPrefs")]
[Description("Loads a float value from PlayerPrefs using a specified key name")]
[Version (1,0,0)]
[Category("Storage/Load Float From PlayerPrefs")]

[Parameter("Key Name", "The key name under which the float value will be loaded")]
[Parameter("Store Value", "The variable where the loaded float value will be stored")]

[Keywords("Load", "Float", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Blue)]

[Serializable]
public class InstructionLoadFloatFromPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------
    
    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertySetNumber m_StoreValue;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Load Float from PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot load from PlayerPrefs.");
            return DefaultResult;
        }
        // Attempt to load the float value from PlayerPrefs
        float keyValue = PlayerPrefs.GetFloat(keyName, 0f); // Default to 0f if key does not exist
        // Set the loaded value to the specified variable
        this.m_StoreValue.Set(keyValue, args);
        return DefaultResult;
    }
}
