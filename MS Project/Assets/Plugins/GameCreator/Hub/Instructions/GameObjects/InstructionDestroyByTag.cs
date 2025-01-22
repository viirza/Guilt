using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Version(1, 0, 0)]

[Title("Destroy By Tag")]
[Description("To destroy any object by tag")]

[Parameter(
        "Tag",
        "destroy any object by tag"
    )]

[Category("Game Objects/Destroy By Tag")]

[Keywords("tag", "destroy", "object")]

[Image(typeof(IconTag), ColorTheme.Type.Red)]

[Serializable]
public class InstructionDestroyByTag : Instruction
{
 

    // RUN METHOD: ----------------------------------------------------------------------------
    [SerializeField] private TagValue tagToDestroy = new TagValue();
    protected override Task Run(Args args)
    {
        GameObject[] objects = GameObject.FindGameObjectsWithTag(this.tagToDestroy.Value);
        foreach (GameObject obj in objects)
        {
            UnityEngine.Object.Destroy(obj);
        }

        return DefaultResult;
    }

    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title =>
        "Destroy By Tag";

}
