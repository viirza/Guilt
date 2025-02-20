using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;
using System;
using System.Threading.Tasks;

[Version(1, 0, 0)]
[Title("Floor To Int")]
[Description("Applies Math.FloorToInt to a float variable and stores the result in an integer variable")]
[Category("Math/Floor To Int")]

[Parameter("Float Variable", "The float variable to be floored")]
[Parameter("Int Variable", "The integer variable where the result will be stored")]

[Serializable]
public class InstructionFloorToInt : Instruction
{
    [SerializeField] private PropertyGetDecimal m_FloatVariable = new PropertyGetDecimal();
    [SerializeField] private PropertySetNumber m_IntVariable = new PropertySetNumber();

    public override string Title => $"Floor {this.m_FloatVariable} and store in {this.m_IntVariable}";

    protected override Task Run(Args args)
    {
        float floatValue = (float)m_FloatVariable.Get(args);
        int intValue = Mathf.FloorToInt(floatValue);

        this.m_IntVariable.Set(intValue, args);

        return DefaultResult;
    }
}

