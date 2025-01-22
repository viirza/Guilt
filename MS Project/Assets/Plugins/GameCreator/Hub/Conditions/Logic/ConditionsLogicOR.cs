using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using UnityEngine;

namespace GameCreator.Runtime.VisualScripting
{
    [Version(0, 0, 1)]
    
    [Title("OR Conditions")]
    [Description(
        "Returns if any of the following conditions is true"
    )]

    [Category("Logic/OR Conditions")]

    [Parameter(
        "Conditions",
        "List of Conditions that can evaluate to true or false"
    )]

    [Keywords("Or", "OR", "Conditions", "Check", "Evaluate")]
    [Image(typeof(IconCondition), ColorTheme.Type.Yellow)]
    
    [Serializable]
    public class ConditionsLogicOR : Condition
    {
        // MEMBERS: -------------------------------------------------------------------------------
        [SerializeField] private ConditionList m_Conditions = new ConditionList();

        // PROPERTIES: ----------------------------------------------------------------------------
        protected override string Summary => this.m_Conditions.Length switch
        {
            0 => "(none)",
            _ => $"OR ({this.m_Conditions.Length} Conditions)"
        };

        // RUN METHOD: ----------------------------------------------------------------------------
        protected override bool Run(Args args)
        {
            if (this.m_Conditions.Length == 0) return true;
            for (int i = 0; i < this.m_Conditions.Length; i++) {
                if (this.m_Conditions.Get(i).Check(args)) {
                    return true;
                }
            }
            return false;
        }
    }
}