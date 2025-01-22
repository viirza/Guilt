using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

namespace GVL.GameCreator.Runtime.VisualScripting
{
    [Version(2, 0, 0)]
    
    [Title("Game Object Move Direction")]
    [Description("Game Object Move Direction")]

    [Category("Game Objects/Game Object Move Direction")]
    [Image(typeof(IconMove), ColorTheme.Type.Green)]
    [Serializable]
    public class InstructionGameObjectMoveDirection : Instruction
    {
        
        // MEMBERS: -------------------------------------------------------------------------------

        [SerializeField] private PropertyGetGameObject m_GameObject = new PropertyGetGameObject();
        [SerializeField] private PropertyGetDirection m_Direction = new PropertyGetDirection();
        [SerializeField] private PropertyGetDecimal m_Speed = new PropertyGetDecimal();
        [SerializeField] private PropertyGetDecimal m_TimeScale = new PropertyGetDecimal();
        
        // PROPERTIES: ----------------------------------------------------------------------------
        public override string Title => $"{m_GameObject} move along {m_Direction} at {m_Speed} * {m_TimeScale}";
        
        protected override Task Run(Args args)
        {
            var go = m_GameObject.Get(args);
            if (go != null)
            {
                go.transform.position += m_Direction.Get(args) * (float)m_Speed.Get(args) * (float)m_TimeScale.Get(args);
            }
            
            return DefaultResult;
        }
    }
}