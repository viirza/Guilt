using System;
using GameCreator.Runtime.Characters;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

namespace GameCreator.Runtime.Quests
{
    [Version(1, 0, 1)]
    [Dependency("Quests", 2, 3, 8)]
    [Title("On Any Task Completed From Quest")]
    [Category("Quests/On Any Task Completed From Quest")]
    [Description("Executes after any Task from a specified Quest is completed")]

    [Example("Useful for in-game Journal update notices. I specifically used this by creating a Quest with Tasks for things you can learn about a character, then on Complete (using this Event) spawn a pop-up UI that notifies the player that that information has been recorded.")]

    [Keywords("Journal", "Mission")]
    [Image(typeof(IconTaskSolid), ColorTheme.Type.Green)]

    [Serializable]
    public class EventOnAnyTaskComplete : VisualScripting.Event
    {
        [SerializeField] private PropertyGetGameObject m_Journal = GetGameObjectPlayer.Create();
        [SerializeField] private CompareQuestOrAny m_Quest = new CompareQuestOrAny();

        // PROPERTIES: ----------------------------------------------------------------------------

        protected Journal Journal { get; private set; }
        private Args Args { get; set; }

        // INITIALIZERS: --------------------------------------------------------------------------

        protected override void OnStart(Trigger trigger)
        {
            base.OnStart(trigger);

            this.Journal = this.m_Journal.Get<Journal>(trigger);
            if (this.Journal == null) return;

            this.Args = new Args(this.Self, this.Journal.gameObject);
            this.Subscribe();
        }

        protected override void OnEnable(Trigger trigger)
        {
            base.OnEnable(trigger);

            this.Journal = this.m_Journal.Get<Journal>(trigger);
            if (this.Journal == null) return;

            this.Args = new Args(this.Self, this.Journal.gameObject);
            this.Subscribe();
        }

        protected override void OnDisable(Trigger trigger)
        {
            base.OnDisable(trigger);

            if (this.Journal == null) return;
            this.Unsubscribe();
        }

        // PROTECTED METHODS: ---------------------------------------------------------------------

        protected void OnChange(Quest quest, int taskId)
        {
            if (!this.m_Quest.Match(quest, this.Args)) return;
            _ = this.m_Trigger.Execute(this.Args);
        }

        // ABSTRACT METHODS: ----------------------------------------------------------------------

        private void Subscribe()
        {
            this.Journal.EventTaskComplete -= this.OnChange;
            this.Journal.EventTaskComplete += this.OnChange;
        }

        private void Unsubscribe()
        {
            if (this.Journal == null) return;
            this.Journal.EventTaskActivate -= this.OnChange;
        }
    }
}
