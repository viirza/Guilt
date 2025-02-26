using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Characters;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Version(1, 0, 2)]

[Title("Play Custom Footstep")]
[Description("Play a custom footstep sound based on the material the player is stepping on")]
[Category("Characters/Footsteps/Play Custom Footstep")]
[Keywords("Footstep", "Custom", "Play")]

[Parameter("Character", "The character target")]
[Parameter("Material Sounds Asset", "The material sounds asset")]

[Image(typeof(IconFootprint), ColorTheme.Type.Green)]
[Serializable]
public class InstructionPlayCustomFootstep : Instruction
{
    // MEMBERS: ----------------------------------------------------------------------------
    [SerializeField] private PropertyGetGameObject m_Character = GetGameObjectPlayer.Create();
    [SerializeField] private MaterialSoundsAsset m_MaterialSoundsAsset; 
    
    // PROPERTIES: ----------------------------------------------------------------------------
    public override string Title => $"Play Custom Footstep on {m_Character}";
    
    // RUN METHOD: ----------------------------------------------------------------------------
    protected override Task Run(Args args)
    {
        var character = m_Character.Get<Character>(args);
        var materialSoundsAsset = m_MaterialSoundsAsset;
        
        if (character == null) return DefaultResult;
        if (materialSoundsAsset == null) return DefaultResult;

        var characterTransform = character.transform;
        var rayOrigin = characterTransform.position;
        var rayDirection = Vector3.down;

        if (Physics.Raycast(rayOrigin, rayDirection, out RaycastHit hit, 1.5f, m_MaterialSoundsAsset.MaterialSounds.LayerMask))
        {
            // Check if the hit object is a terrain or a mesh and play the corresponding sound
            MaterialSounds.Play(args, hit.point, hit.normal, hit.collider.gameObject, m_MaterialSoundsAsset, characterTransform.eulerAngles.y);
        }

        return DefaultResult;
    }
}
