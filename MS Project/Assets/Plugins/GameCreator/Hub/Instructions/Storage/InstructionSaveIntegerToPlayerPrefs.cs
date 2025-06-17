using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Title("Save Integer to PlayerPrefs")]
[Description("Saves an integer value to PlayerPrefs with a specified key name")]
[Version (1,0,0)]
[Category("Storage/Save Integer to PlayerPrefs")]

[Parameter("Key Name", "The key name under which the integer value will be saved")]
[Parameter("Value", "The integer value to be saved to PlayerPrefs")]

[Keywords("Save", "Float", "Integer", "Variable","Value", "PlayerPrefs")]
[Image(typeof(IconDiskSolid), ColorTheme.Type.Green)]

[Serializable]
public class InstructionSaveIntegerToPlayerPrefs : Instruction
{
    // EXPOSED MEMBERS: -----------------------------------------------------------------------

    [SerializeField] private PropertyGetString m_KeyName = GetStringId.Create("");
    [SerializeField] private PropertyGetInteger m_Value;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Save {this.m_Value} to PlayerPrefs with key '{this.m_KeyName}'";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        string keyName = this.m_KeyName.Get(args);
        int keyValue = (int)this.m_Value.Get(args);
        if (string.IsNullOrEmpty(keyName))
        {
            Debug.LogWarning("Key name is empty. Cannot save to PlayerPrefs.");
            return DefaultResult;
        }
        
        PlayerPrefs.SetInt(keyName, keyValue);
        PlayerPrefs.Save();
        return DefaultResult;
    }
}
