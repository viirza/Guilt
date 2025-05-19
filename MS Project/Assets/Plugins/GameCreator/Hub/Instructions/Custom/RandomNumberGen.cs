using System;
using System.Threading.Tasks;
using UnityEngine;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;

[Version(1, 0, 2)]
[Title("Generate Random Number")]
[Category("Custom/Random")]
[Description("Generates a random integer between two specified values (inclusive) and stores it in a variable")]
[Image(typeof(IconDice), ColorTheme.Type.TextLight)]
[Keywords("Random", "Number", "Generate", "Integer", "Range", "Variable", "Math", "Value")]
[Serializable]
public class RandomNumberGen : Instruction
{
    [SerializeField]
     private PropertyGetInteger minValue = new PropertyGetInteger(1);

    [SerializeField]
    private PropertyGetInteger maxValue = new PropertyGetInteger(5);

    [SerializeField]
    private PropertySetNumber storeNumber = new PropertySetNumber();

    public override string Title => $"Store random number between {minValue} and {maxValue}";

    protected override Task Run(Args args)
    {
        int min = (int)this.minValue.Get(args);
        int max = (int)this.maxValue.Get(args);
        int randomValue = UnityEngine.Random.Range(min, max + 1);
        this.storeNumber.Set(randomValue, args);
        //Debug.Log($"Generated random number: {randomValue}");
        return DefaultResult;
    }
}