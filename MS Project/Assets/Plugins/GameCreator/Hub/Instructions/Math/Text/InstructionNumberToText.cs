using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;

[Version(1, 0, 0)]

[Title("Number To Text")]
[Description("Converts number value to string value")]
[Category("Math/Text/Number To Text")]

[Parameter("Number", "The numeric value to convert")]
[Parameter("Text", "The string object to save the result to")]

[Keywords("Text", "String", "Number", "Convert")]
[Image(typeof(IconArrowCircleDown), ColorTheme.Type.Blue)]

[Serializable]
public class InstructionNumberToText : Instruction
{
    public PropertyGetDecimal m_Number = new PropertyGetDecimal();
    public PropertySetString m_Text = new PropertySetString();
    
    public override string Title => $"Convert number {this.m_Number} to string {this.m_Text}";

    protected override Task Run(Args args)
    {
        this.m_Text.Set(this.m_Number.Get(args).ToString(), args);
        return DefaultResult;
    }
}
