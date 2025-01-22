using System;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;

namespace GameCreator.Runtime.Dialogue.UnityUI
{
    [Version(1, 0, 2)]
    [Title("Is Dialogue UI Open")]
    [Description("Returns true if the there is a Dialogue UI open")]

    [Category("Dialogue/UI/Is Dialogue UI Open")]

    [Keywords("Close", "Dialogue", "Conversation")]
    
    [Image(typeof(IconDialogue), ColorTheme.Type.Green)]

    [Dependency("dialogue", 2, 0, 6)]
    [Serializable]
    public class ConditionDialogueIsOpenDialogueUI : Condition
    {
    // PROPERTIES: ----------------------------------------------------------------------------

    protected override string Summary => "Dialogue UI is Open";

    // RUN METHOD: ----------------------------------------------------------------------------

    protected override bool Run(Args args)
        {
            return DialogueUI.IsOpen;
        }
    }
}