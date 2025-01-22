using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using UnityEngine;
using UnityEngine.UI;

namespace GameCreator.Runtime.VisualScripting
{
    [Version(1, 0, 1)]

    [Title("Button Interactable")]
    [Category("UI/Button Interactable")]

    [Image(typeof(IconUIButton), ColorTheme.Type.TextLight)]
    [Description("Changes the interactable value of a Button component")]

    [Parameter("Button ", "The Button component that changes its value")]
    [Parameter("Interactable", "The on/off state value")]

    [Serializable]
    public class InstructionUIButtonInteractable : Instruction
    {
        [SerializeField] private PropertyGetGameObject m_Button = GetGameObjectInstance.Create();
        [SerializeField] private PropertyGetBool m_Interactable = GetBoolValue.Create(true);

        public override string Title => $"{this.m_Button} Interactable = {this.m_Interactable}";

        protected override Task Run(Args args)
        {
            GameObject gameObject = this.m_Button.Get(args);
            if (gameObject == null) return DefaultResult;

            Button s_Button = gameObject.Get<Button>();
            if (s_Button == null) return DefaultResult;

            s_Button.interactable = this.m_Interactable.Get(args);
            return DefaultResult;
        }
    }
}