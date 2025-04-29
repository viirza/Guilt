using System;
using System.Threading.Tasks;
using UnityEngine;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using GameCreator.Runtime.Variables;

[Version(1, 0, 15)]
[Title("Save Global Var to PlayerPrefs")]
[Category("Variables/Save Global Var to PlayerPrefs")]
[Description("Saves the value of a global string variable to PlayerPrefs")]

[Keywords("Save", "Global", "PlayerPrefs")]
[Serializable]
public class InstructionSaveVarToJSON : Instruction
{
    [SerializeField] private PropertyGetString variableName = new PropertyGetString("language");
    [SerializeField] private PropertyGetString valueToSave = new PropertyGetString("en");

    protected override Task Run(Args args)
    {
        string key = this.variableName.Get(args);
        string value = this.valueToSave.Get(args);

        string encodedValue = Base64Encode(value); 

        PlayerPrefs.SetString(key, encodedValue);
        PlayerPrefs.Save();

        Debug.Log($"[InstructionSaveVarToJSON] Saved {key} = {encodedValue} (Base64) to PlayerPrefs");
        return Task.CompletedTask;
    }

    public static string Base64Encode(string plainText)
    {
        var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
        return System.Convert.ToBase64String(plainTextBytes);
    }

    [Serializable]
    private class SaveData
    {
        public string key;
        public string value;
    }
}