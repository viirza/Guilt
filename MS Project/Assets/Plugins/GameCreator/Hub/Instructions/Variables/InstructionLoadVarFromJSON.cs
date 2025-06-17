using System;
using System.Threading.Tasks;
using UnityEngine;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using GameCreator.Runtime.Variables;

[Version(1, 0, 15)]
[Title("Load PlayerPrefs to Global Var")]
[Category("Variables/Load PlayerPrefs to Global Var")]
[Description("Loads a value from PlayerPrefs and stores it into a global variable")]

[Keywords("Load", "Global", "PlayerPrefs")]
[Serializable]
public class InstructionLoadVarFromJSON : Instruction
{
    [SerializeField] private PropertyGetString variableName = new PropertyGetString("language");
    [SerializeField] private PropertySetString storeResult = new PropertySetString();

    protected override Task Run(Args args)
    {
        string key = this.variableName.Get(args);

        if (PlayerPrefs.HasKey(key))
        {
            string encodedValue = PlayerPrefs.GetString(key);
            string value = Base64Decode(encodedValue); 
            storeResult.Set(value, args);
            Debug.Log($"[InstructionLoadVarFromJSON] Loaded {key} = {value} (decoded) from PlayerPrefs");
        }
        else
        {
            Debug.LogWarning($"[InstructionLoadVarFromJSON] Key not found in PlayerPrefs: {key}");
        }

        return Task.CompletedTask;
    }

    public static string Base64Decode(string base64EncodedData)
    {
        var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
        return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
    }
}