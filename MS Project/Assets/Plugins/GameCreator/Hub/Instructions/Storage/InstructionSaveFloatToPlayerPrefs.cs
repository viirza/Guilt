using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Save Float To PlayerPrefs")]
[Description("Saves a float value to PlayerPrefs with a specified key name")]
[Version (1,0,0)]
[Category("Storage/Save Float To PlayerPrefs")]

[Parameter("Key Name", "The key name under which the float value will be saved")]
[Parameter("Value", "The float value to be saved to PlayerPrefs")]

[Keywords("Save", "Float", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Green)]

[Serializable]
public class InstructionSaveFloatToPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------
    
    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertyGetDecimal m_Value;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Save {this.m_Value} to PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        float keyValue = (float)this.m_Value.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot save to PlayerPrefs.");
            return DefaultResult;
        }
        
        // Attempt to save the float value to PlayerPrefs
        PlayerPrefs.SetFloat(keyName, keyValue);
        PlayerPrefs.Save();
        return DefaultResult;
    }
}
