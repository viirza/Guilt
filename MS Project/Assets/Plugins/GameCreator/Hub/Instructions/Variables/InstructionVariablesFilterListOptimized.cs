using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.Variables;
using UnityEngine;

namespace GameCreator.Runtime.VisualScripting
{
    [Version(1, 0, 3)]

    [Title("Filter List [Optimized]")]
    [Category("Variables/Filter List [Optimized]")]
    [Description("Optimized version of the default 'Filter List' instruction")]
    
    [Parameter("List Variable", "Local List or Global List which elements are filtered")]
    [Parameter(
        "Filter", 
        "Checks a set of Conditions with each collected game object and removes the element " +
        "if the Condition is not true"
    )]

    [Example(
        "The Filter field runs the Conditions list for each element in a Local List Variables " +
        "or Global List Variables. It sets as the 'Target' value the currently examined game " +
        "object. For example, filtering by the tag name 'Enemy' can be done using the 'Tag' " +
        "Condition and comparing the field 'Target' with the string 'Enemy'. All game objects " +
        "that are not tagged as 'Enemy' are removed"
    )]
    
    [Image(typeof(IconFilter), ColorTheme.Type.Teal, typeof(OverlayBolt))]
    
    [Keywords("Remove", "Pick", "Select", "Array", "List", "Variables")]
    [Serializable]
    public class InstructionVariablesFilterListOptimized : Instruction
    {
        // MEMBERS: -------------------------------------------------------------------------------

        [SerializeField] 
        private CollectorListVariable m_ListVariable = new CollectorListVariable();

        [SerializeField] private CheckMode m_CheckMode = CheckMode.And;
        [SerializeField, Space(2)] private ConditionList m_Conditions = new ConditionList();

        [NonSerialized] private List<GameObject> m_Buffer = new List<GameObject>();
        [NonSerialized] private Args m_Args;
        
        // PROPERTIES: ----------------------------------------------------------------------------

        public override string Title => $"Filter {this.m_ListVariable}";

        // RUN METHOD: ----------------------------------------------------------------------------
        
        protected override Task Run(Args args)
        {
            if (this.m_Args == null) this.m_Args = new Args(args.Self, null);
            else this.m_Args.ChangeSelf(args.Self);

            this.m_Buffer.Clear();
            List<object> source = this.m_ListVariable.Get(args);

            for (int i = 0; i < source.Count; ++i)
            {
                GameObject gameObject = source[i] as GameObject;
                if (gameObject == null) continue;
                
                this.m_Args.ChangeTarget(gameObject);
                if (this.m_Conditions.Check(this.m_Args, this.m_CheckMode))
                {
                    this.m_Buffer.Add(gameObject);
                }
            }

            this.m_ListVariable.Fill(this.m_Buffer.ToArray(), args);
            return DefaultResult;
        }
    }
}