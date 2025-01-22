using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Version(1, 0, 2)]
    
[Title("Run Actions N Times")]
[Description("Executes an Actions component N times")]

[Category("Logic/Run Actions N Times")]

[Parameter(
    "Actions",
    "The Actions object that is executed"
)]

[Parameter(
    "Times",
    "The amount of times the Actions are executed"
)]
    
[Keywords("Execute", "Call", "Instruction", "Repeat")]
[Image(typeof(IconInstructions), ColorTheme.Type.Blue, typeof(OverlayDot))]

[Serializable]
public class InstructionExecuteNTimes : Instruction
{
    [SerializeField] private PropertyGetGameObject m_Actions = GetGameObjectActions.Create();
    [SerializeField] private PropertyGetInteger m_Times = GetDecimalInteger.Create(5);
    
    public override string Title => $"Run {this.m_Actions} {this.m_Times} times";
    
    protected override async Task Run(Args args)
    {
        Actions actions = this.m_Actions.Get<Actions>(args);
        int times = (int) this.m_Times.Get(args);
        
        if (actions == null) return;

        for (int i = 0; i < times; ++i)
        {
            await actions.Run(args);
        }
    }
}
