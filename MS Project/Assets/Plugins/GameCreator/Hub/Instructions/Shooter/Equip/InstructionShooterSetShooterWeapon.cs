using System;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

namespace GameCreator.Runtime.Shooter
{
	[Version(1, 0, 0)]
	[Title("Set Shooter Weapon")]
	[Description("Sets the Shooter Weapon value")]
    [Dependency("shooter", 2, 0, 1)]

	[Category("Shooter/Equip/Set Shooter Weapon")]

    [Parameter("Set", "Where the value is set")]
    [Parameter("From", "The value that is set")]

	[Keywords("Shooter", "Equip", "Variable", "Weapon")]
	[Image(typeof(IconBullet), ColorTheme.Type.Blue)]
    
    [Serializable]
    public class InstructionShooterSetShooterWeapon : Instruction
    {
        // MEMBERS: -------------------------------------------------------------------------------
        
        [SerializeField] 
	    private PropertySetWeapon m_Set = SetWeaponNone.Create;
        
        [SerializeField]
	    private PropertyGetWeapon m_From = new PropertyGetWeapon();

        // PROPERTIES: ----------------------------------------------------------------------------
        
        public override string Title => $"Set {this.m_Set} = {this.m_From}";

        // RUN METHOD: ----------------------------------------------------------------------------
        
        protected override System.Threading.Tasks.Task Run(Args args)
        {
	        ShooterWeapon value = this.m_From.Get(args) as ShooterWeapon;
            this.m_Set.Set(value, args);

            return DefaultResult;
        }
    }
}