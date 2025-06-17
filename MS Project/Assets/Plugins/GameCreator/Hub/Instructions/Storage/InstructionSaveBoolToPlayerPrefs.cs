using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Save Bool To PlayerPrefs")]
[Description("Saves a boolean value to PlayerPrefs with a specified key name")]
[Version (1,0,0)]
[Category("Storage/Save Bool To PlayerPrefs")]

[Parameter("Key Name", "The key name under which the boolean value will be saved")]
[Parameter("Value", "The boolean value to be saved to PlayerPrefs")]

[Keywords("Save", "Bool", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Green)]

[Serializable]
public class InstructionSaveBoolToPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------
    
    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertyGetBool m_Value = GetBoolValue.Create(false);
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Save {this.m_Value} to PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        bool keyValue = this.m_Value.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot save to PlayerPrefs.");
            return DefaultResult;
        }
        
        // Attempt to save the boolean value to PlayerPrefs
        PlayerPrefs.SetInt(keyName, keyValue ? 1 : 0); // Convert bool to int (1 for true, 0 for false)
        PlayerPrefs.Save();
        return DefaultResult;
    }
}
