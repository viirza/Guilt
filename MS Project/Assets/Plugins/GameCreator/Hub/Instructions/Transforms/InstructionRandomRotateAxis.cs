using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using Unity.Mathematics;
using UnityEngine;
using Random = UnityEngine.Random;


[Version(1, 0, 1)]

[Title("Random Rotate Axis")]
[Description("Rotates an axis from a chosen minimum and maximum number in degrees.")]

[Parameter("Axis", "Axis you want to rotate")]
[Parameter("Rotation", "How you want to be rotating ( Set,Add or Subtract )")]
[Parameter("Minimum", "Minimum degree")]
[Parameter("Maximum", "Maximum degree")]
[Parameter("Transform", "Game Object to be rotated")]

[Category("Transforms/Random Rotate Axis")]

[Image(typeof(IconRotation),ColorTheme.Type.Yellow)]

[Serializable]
public class InstructionRandomRotateAxis : Instruction
{
    
    
    // MEMBERS: -------------------------------------------------------------------------------
    
    [SerializeField] private Axis m_Axis;
    [SerializeField] private Rotation m_Rotation;
    
    [SerializeField] private PropertyGetDecimal m_Minimum;
    [SerializeField] private PropertyGetDecimal m_Maximum;
    [SerializeField] private PropertyGetGameObject m_Transform;
    
    // PROPERTIES: ----------------------------------------------------------------------------
    
    [Serializable]
    private enum Axis
    {
        X,Y,Z
    }
    [Serializable]
    private enum Rotation
    {
        Set,Add,Subtract
    }

    public override string Title => string.Format(
        "Rotate {0}'s {1} Axis by {2} - {3} degrees",
        this.m_Transform,
        this.m_Axis,
        this.m_Minimum,
        this.m_Maximum);
    
    // RUN METHOD: ----------------------------------------------------------------------------
    
    
    protected override Task Run(Args args)
    {
        var minimum = this.m_Minimum.Get(args);
        var maximum = this.m_Maximum.Get(args);
        var transform = this.m_Transform.Get(args);
        
        if (minimum == 0 && maximum == 0 || transform == null) return DefaultResult;
        
        switch (m_Axis)
        {
            case Axis.X :
                switch (m_Rotation)
                {
                    case Rotation.Set :
                        transform.transform.eulerAngles = new Vector3(Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.y,transform.transform.eulerAngles.z);
                        break;
                    case Rotation.Add :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x + Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.y,transform.transform.eulerAngles.z);
                        break;
                    case Rotation.Subtract :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x - Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.y,transform.transform.eulerAngles.z);
                        break;
                }
                break;
            case Axis.Y :
                switch (m_Rotation)
                {
                    case Rotation.Set :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.z);
                        break;
                    case Rotation.Add :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,transform.transform.eulerAngles.y + Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.z);
                        break;
                    case Rotation.Subtract :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,transform.transform.eulerAngles.y - Random.Range((float)minimum, (float)maximum),transform.transform.eulerAngles.z);
                        break;
                }
                break;
            case Axis.Z :
                switch (m_Rotation)
                {
                    case Rotation.Set :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,transform.transform.eulerAngles.y,Random.Range((float)minimum, (float)maximum));
                        break;
                    case Rotation.Add :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,transform.transform.eulerAngles.y,transform.transform.eulerAngles.z + Random.Range((float)minimum, (float)maximum));
                        break;
                    case Rotation.Subtract :
                        transform.transform.eulerAngles = new Vector3(transform.transform.eulerAngles.x,transform.transform.eulerAngles.y,transform.transform.eulerAngles.z - Random.Range((float)minimum, (float)maximum));
                        break;
                }
                break;
        }
        return DefaultResult;
    }
}
