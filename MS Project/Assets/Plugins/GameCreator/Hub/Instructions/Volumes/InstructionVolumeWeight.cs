using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering;

[Version(0, 0, 1)]
[RenderPipeline(false, true, true)]

[Title("Volume Weight")]
[Description("Changes the Volume weight")]
[Category("Volumes/Volume Weight")]

[Parameter("Volume", "The game object with the Volume")]
[Parameter("Weight", "The new Weight value")]

[Image(typeof(IconCubeSolid), ColorTheme.Type.Purple)]

[Serializable]
public class InstructionVolumeWeight : Instruction
{
    [SerializeField] private PropertyGetGameObject m_Volume = GetGameObjectInstance.Create();
    [SerializeField] private PropertyGetDecimal m_Weight = GetDecimalConstantOne.Create;
    [SerializeField] private Transition m_Transition = new Transition();

    protected override async Task Run(Args args)
    {
        Volume volume = this.m_Volume.Get<Volume>(args);
        if (volume == null) return;

        float valueSource = volume.weight;    
        float valueTarget = (float) this.m_Weight.Get(args);

        ITweenInput tween = new TweenInput<float>(
            valueSource,
            valueTarget,
            this.m_Transition.Duration,
            (a, b, t) => volume.weight = Mathf.LerpUnclamped(a, b, t),
            Tween.GetHash(typeof(Volume), "weight"),
            this.m_Transition.EasingType,
            this.m_Transition.Time
        );
        
        Tween.To(volume.gameObject, tween);
        if (this.m_Transition.WaitToComplete) await this.Until(() => tween.IsFinished);
    }
}
