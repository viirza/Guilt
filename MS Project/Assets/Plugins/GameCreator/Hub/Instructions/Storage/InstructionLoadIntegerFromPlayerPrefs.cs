using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Load Integer From PlayerPrefs")]
[Description("Loads an integer value from PlayerPrefs using a specified key name")]
[Version (1,0,0)]
[Category("Storage/Load Integer From PlayerPrefs")]

[Parameter("Key Name", "The key name under which the integer value will be loaded")]
[Parameter("Store Value", "The variable where the loaded integer value will be stored")]

[Keywords("Load", "Integer", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Blue)]

[Serializable]
public class InstructionLoadIntegerFromPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------
    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertySetNumber m_StoreValue;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Load Integer from PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot load from PlayerPrefs.");
            return DefaultResult;
        }
        // Attempt to load the integer value from PlayerPrefs
        int keyValue = PlayerPrefs.GetInt(keyName, 0); // Default to 0 if key does not exist
        // Set the loaded value to the specified variable
        this.m_StoreValue.Set(keyValue, args);
        return DefaultResult;
    }
}
