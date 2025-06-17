using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Load Bool From PlayerPrefs")]
[Description("Loads a boolean value from PlayerPrefs using a specified key name")]
[Version (1,0,0)]
[Category("Storage/Load Bool From PlayerPrefs")]

[Parameter("Key Name", "The key name under which the boolean value will be loaded")]
[Parameter("Store Value", "The variable where the loaded boolean value will be stored")]

[Keywords("Load", "Bool", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Blue)]

[Serializable]
public class InstructionLoadBoolFromPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------
    
    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertySetBool m_StoreValue;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    
    public override string Title => $"Load Bool from PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot load from PlayerPrefs.");
            return DefaultResult;
        }
        // Attempt to load the boolean value from PlayerPrefs
        int keyValueInt = PlayerPrefs.GetInt(keyName, 0); // Default to 0 if key does not exist
        bool keyValue = keyValueInt != 0; // Convert int back to bool (0 for false, non-zero for true)
        // Set the loaded value to the specified variable
        this.m_StoreValue.Set(keyValue, args);
        return DefaultResult;
    }
}
