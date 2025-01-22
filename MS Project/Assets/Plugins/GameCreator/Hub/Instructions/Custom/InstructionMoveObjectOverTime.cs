using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;
using System.Threading.Tasks;
using System;
[Version(1, 0, 0)]
[Title("Move Object Over Time")]
[Description("Moves a GameObject with a collider over a set distance in a specified direction and timeframe")]

[Category("Custom/Move Object Over Time")]

[Parameter("Target", "The GameObject to move")]
[Parameter("Direction", "The direction to move the GameObject")]
[Parameter("Distance", "The distance to move the GameObject")]
[Parameter("Timeframe", "The time over which to move the GameObject")]

[Keywords("Move", "Direction", "Distance", "Timeframe")]

//[Image(typeof(IconMotion), ColorTheme.Type.Green)]

[Serializable]
public class InstructionMoveObjectOverTime : Instruction
{
    [SerializeField] private PropertyGetGameObject m_Target;
    [SerializeField] private Vector3 m_Direction;
    [SerializeField] private float m_Distance;
    [SerializeField] private float m_Timeframe;

    public override string Title => $"Move {this.m_Target} by {this.m_Distance} units in {this.m_Direction} over {this.m_Timeframe} seconds";

    protected override async Task Run(Args args)
    {
        GameObject target = this.m_Target.Get(args);
        if (target == null) return;

        Vector3 startPosition = target.transform.position;
        Vector3 endPosition = startPosition + this.m_Direction.normalized * this.m_Distance;

        float elapsedTime = 0;
        while (elapsedTime < this.m_Timeframe)
        {
            target.transform.position = Vector3.Lerp(startPosition, endPosition, elapsedTime / this.m_Timeframe);
            elapsedTime += UnityEngine.Time.deltaTime;
            await Task.Yield();
        }

        target.transform.position = endPosition;
    }
}

