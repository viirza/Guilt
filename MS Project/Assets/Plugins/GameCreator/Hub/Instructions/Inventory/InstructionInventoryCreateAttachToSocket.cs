using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Characters;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

namespace GameCreator.Runtime.Inventory
{
    [Version(0, 2, 3)]
    [Dependency("inventory", 2, 8, 16)]
    
    [Title("Add Item with Sockets")]
    [Description("Creates a new item with Sockets and adds it to the specified Bag")]

    [Category("Inventory/Add Item with Sockets")]
    
    [Parameter("Item", "The type of item created")]
    [Parameter("Attachments", "The Attachments to add")]
    [Parameter("Bag", "The targeted Bag component")]

    [Keywords("Bag", "Inventory", "Container", "Stash")]
    [Keywords("Give", "Take", "Borrow", "Lend", "Buy", "Purchase", "Sell", "Steal", "Rob")]
    
    [Image(typeof(IconItem), ColorTheme.Type.Green, typeof(OverlayPlus))]
    
    [Serializable]
    public class InstructionInventoryCreateAttachToSocket : Instruction
    {
        // MEMBERS: -------------------------------------------------------------------------------

        [SerializeField] private PropertyGetItem m_Item = new PropertyGetItem();
        [SerializeField] private PropertyGetItem[] m_Attachments = Array.Empty<PropertyGetItem>();
        
        [SerializeField] private PropertyGetGameObject m_Bag = GetGameObjectPlayer.Create();

        // PROPERTIES: ----------------------------------------------------------------------------

        public override string Title => $"Add {this.m_Item} to {this.m_Bag}";

        // RUN METHOD: ----------------------------------------------------------------------------

        protected override Task Run(Args args)
        {
            Item item = this.m_Item.Get(args);
            if (item == null) return DefaultResult;
            
            Bag bag = this.m_Bag.Get<Bag>(args);
            if (bag == null) return DefaultResult;

            RuntimeItem runtimeItem = item.CreateRuntimeItem(args);
            foreach (PropertyGetItem value in this.m_Attachments)
            {
                Item attachment = value.Get(args);
                if (attachment == null) continue;

                RuntimeItem runtimeAttachment = attachment.CreateRuntimeItem(args);
                if (runtimeAttachment == null) continue;
                
                runtimeItem.Sockets.Attach(runtimeItem, runtimeAttachment);
            }

            bag.Content.Add(runtimeItem, true);
            return DefaultResult;
        }
    }
}