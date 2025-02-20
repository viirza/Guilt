using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

namespace GVL.GameCreator.Runtime.VisualScripting
{
    [Version(2, 0, 0)]
    
    [Title("Time Converter")]
    [Description("Convert time in seconds into HH:MM:SS:mm")]
    [Category("Time/Time Converter")]
    [Image(typeof(IconTimer), ColorTheme.Type.Yellow)]
    
    [Serializable]
    public class InstructionTimeConvert : Instruction
    {
        
        // MEMBERS: -------------------------------------------------------------------------------
        [SerializeField] private PropertyGetDecimal m_InputSeconds = new PropertyGetDecimal();
        [Space] 
        // [SerializeField] private PropertySetString m_HH = new PropertySetString();
        // [SerializeField] private PropertySetString m_MM = new PropertySetString();
        // [SerializeField] private PropertySetString m_SS = new PropertySetString();
        // [SerializeField] private PropertySetString m_mm = new PropertySetString();
        private PropertySetString m_HHMMSSmm = new PropertySetString();

        // PROPERTIES: ----------------------------------------------------------------------------
        public override string Title => $"Convert {m_InputSeconds} seconds into HH:MM:SS";
        
        // RUN METHOD: ----------------------------------------------------------------------------
        protected override Task Run(Args args)
        {
            TimeSpan time = TimeSpan.FromSeconds(m_InputSeconds.Get(args));
            m_HHMMSSmm.Set(time.ToString(@"hh\:mm\:ss\:fff"), args);
            return DefaultResult;
        }
    }
}