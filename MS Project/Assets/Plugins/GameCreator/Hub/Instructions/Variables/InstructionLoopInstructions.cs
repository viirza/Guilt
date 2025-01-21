using UnityEngine;
using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;

[Version(1, 0, 1)]
[Title("Loop Next Instructions")]
[Description("Loop Next X instructions a Y amount of times. This will not stop them from being executed right after, which means that if you loop an instruction 4 times, it will get executed a 5th outside of the loop.")]
[Image(typeof(IconInstructions), ColorTheme.Type.Blue, typeof(OverlayListVariable))]
[Category("Variables/Loop Next Instructions")]

[Parameter("Instruction Count", "The amount of instructions you want to loop right below this one.")]
[Parameter("Loop Count", "The amount of times you want said instructions to loop")]

[Keywords("Iterate", "Cycle", "Every", "All", "Stack", "Loop", "Action")]
[Serializable]
public class InstructionLoopInstructions : Instruction
{
    [SerializeField] private PropertyGetInteger m_InstructionCount = new PropertyGetInteger();
    [SerializeField] private PropertyGetInteger m_LoopCount = new PropertyGetInteger();

    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Loop the next {this.m_InstructionCount} instructions {m_LoopCount} times";

    // RUN METHOD: ----------------------------------------------------------------------------

    protected override async Task Run(GameCreator.Runtime.Common.Args args)
    {
        var count = m_LoopCount.Get(args);
        var actionsCount = m_InstructionCount.Get(args);
        InstructionList parent = this.Parent;
        //Debug.Log("Actions in this parent: " + parent.Length);
        //Debug.Log("Index where this loop is: " + parent.RunningIndex);
        //Debug.Log("ACTIONS TO RUN:");
        InstructionList looplist = new InstructionList();
        
        for (int i = 0; i < count; i++)
        {
            //Debug.Log("Loop " + (i+1));
            for (int j = 0; j < actionsCount; j++)
            {
                Instruction ins = parent.Get(parent.RunningIndex + j+1);
                //Debug.Log("Index " + j + ": " + ins);
                await ins.Schedule(args, parent);
            }
        }
        return;
    }
}