using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using UnityEngine;

namespace GameCreator.Runtime.VisualScripting
{
    [Title("Look At With Duration")]
    [Description("Rotates the transform towards the chosen target over time.")]

    [Image(typeof(IconEye), ColorTheme.Type.Yellow, typeof(OverlayHourglass))]

    [Category("Transforms/Look At With Duration")]
    [Version(1, 0, 1)]

    [Parameter("Target", "The desired targeted object to look at")]
    [Parameter("Space", "If the transformation occurs in local or world space")]
    [Parameter("Duration", "How long it takes to perform the transition")]
    [Parameter("Easing", "The change rate of the rotation over time")]
    [Parameter("Wait to Complete", "Whether to wait until the rotation is finished or not")]

    [Keywords("Rotate", "Rotation", "See", "Look")]
    [Serializable]
    public class InstructionTransformLookAtWithDuration : TInstructionTransform
    {
        [SerializeField] private PropertyGetGameObject m_Target = GetGameObjectTransform.Create();

        [Space]
        [Space][SerializeField] private Space m_Space = Space.Self;
        [SerializeField] private Transition m_Transition = new Transition();

        // PROPERTIES: ----------------------------------------------------------------------------

        public override string Title => $"{this.m_Transform} look at {this.m_Target} over {this.m_Transition.Duration}s";

        // RUN METHOD: ----------------------------------------------------------------------------

        protected override async Task Run(Args args)
        {
            GameObject gameObject = this.m_Transform.Get(args);
            if (gameObject == null) return;

            GameObject target = this.m_Target.Get(args);
            if (target == null) return;

            Vector3 lookDirection = target.transform.position - gameObject.transform.position;

            Quaternion valueSource = this.m_Space switch
            {
                Space.World => gameObject.transform.rotation,
                Space.Self => gameObject.transform.localRotation,
                _ => throw new ArgumentOutOfRangeException()
            };

            Quaternion valueTarget = Quaternion.LookRotation(lookDirection);

            ITweenInput tween = new TweenInput<Quaternion>(
                valueSource,
                valueTarget,
                this.m_Transition.Duration,
                (a, b, t) =>
                {
                    switch (this.m_Space)
                    {
                        case Space.World:
                            gameObject.transform.rotation = Quaternion.LerpUnclamped(a, b, t);
                            break;

                        case Space.Self:
                            gameObject.transform.localRotation = Quaternion.LerpUnclamped(a, b, t);
                            break;

                        default:
                            throw new ArgumentOutOfRangeException();
                    }
                },
                Tween.GetHash(typeof(Transform), "rotation"),
                this.m_Transition.EasingType,
                this.m_Transition.Time
            );

            Tween.To(gameObject, tween);
            if (this.m_Transition.WaitToComplete) await this.Until(() => tween.IsFinished);

        }
    }
}
