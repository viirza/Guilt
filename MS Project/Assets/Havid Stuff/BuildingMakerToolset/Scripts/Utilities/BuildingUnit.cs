using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
namespace BuildingMakerToolset.PropPlacer
{
    [ExecuteInEditMode]
    public class BuildingUnit : MonoBehaviour
    {
#if UNITY_EDITOR
        public bool enableTransformationInheritance = true;
        public List<BuildingUnit> pseudoChildren;
        public BuildingUnit pseudoParent;

        protected Vector3 oldPos;
        protected Quaternion oldRot;
        protected Vector3 oldScale;
        public bool forceTransformChanged = false;
        private void Start()
        {
            if (Application.isPlaying)
                this.enabled = false;
            ResetTransformChanged();
        }


        [ExecuteInEditMode]
        private void Update()
        {
            UpdateInternal();
        }
        public void UpdateInternal()
        {
            if (TransformChanged())
            {
                OnTransformChanged();
            }
        }

        void ResetTransformChanged()
        {
            oldPos = transform.position;
            oldScale = transform.localScale;
            oldRot = transform.rotation;
        }


        public bool TransformChanged()
        {
            bool retVal = false;
            if (forceTransformChanged)
            {
                forceTransformChanged = false;
                retVal = true;
            }
            float threshold = 0.0001f;
            if (Vector3.Distance(oldPos, transform.position) > threshold)
                retVal = true;
            if (Vector3.Distance(oldScale, transform.localScale) > threshold)
                retVal = true;
            if (Quaternion.Angle(oldRot, transform.rotation) > threshold * 90)
                retVal = true;
            ResetTransformChanged();
            return retVal;
        }


        public void ForceUpdate()
        {
            forceTransformChanged = true;
            UpdateInternal();
        }



        bool CheckForInfLoop(BuildingUnit newChild, BuildingUnit newParent)
        {
            bool checkDone = false;
            bool isLoop = false;
            BuildingUnit curParent = newParent;
            while (!checkDone)
            {
                if (curParent == newChild)
                {
                    checkDone = true;
                    isLoop = true;
                }
                curParent = curParent.pseudoParent;
                if (curParent == null)
                    checkDone = true;
            }

            return isLoop;
        }



        public void AddChild(BuildingUnit child, int addAt = -1)
        {
            Undo.RecordObject(this, "Transform Awareness Change");
            Undo.RecordObject(this.transform, "Transform Awareness Change");

            Undo.RecordObject(child, "Transform Awareness Change");
            Undo.RecordObject(child.transform, "Transform Awareness Change");


            if (pseudoChildren == null)
                pseudoChildren = new List<BuildingUnit>();

            if (CheckForInfLoop(child, this))
                return;

            forceTransformChanged = true;

            if (child.pseudoParent != null && child.pseudoParent != this)
                child.pseudoParent.RemoveChild(child);



            child.pseudoParent = this;
            if (!pseudoChildren.Contains(child))
            {
                if (addAt >= 0 && addAt < pseudoChildren.Count && pseudoChildren[addAt] != null)
                {
                    if (pseudoChildren[addAt] != null)
                    {

                        RemoveChild(pseudoChildren[addAt]);
                        pseudoChildren.Insert(addAt, child);
                    }
                    else
                    {
                        pseudoChildren[addAt] = child;
                        return;
                    }
                }
                else
                    pseudoChildren.Add(child);
            }
            UpdateInternal();
        }


        public void RemoveChild(BuildingUnit child)
        {
            forceTransformChanged = true;
            if (child == null)
                return;
            Undo.RecordObject(this, "Transform Awareness Change");
            Undo.RecordObject(this.transform, "Transform Awareness Change");


            Undo.RecordObject(child, "Transform Awareness Change");
            Undo.RecordObject(child.transform, "Transform Awareness Change");

            if (child.pseudoParent == this)
                child.pseudoParent = null;
            if (pseudoChildren.Contains(child))
                pseudoChildren.Remove(child);
        }

        public void CheckIfValid()
        {
            if (pseudoChildren != null && pseudoChildren.Count > 0)
            {
                for (int i = 0; i < pseudoChildren.Count; i++)
                {
                    if (pseudoChildren[i] == null || pseudoChildren[i] == this)
                    {
                        pseudoChildren.RemoveAt(i);
                        i--;
                    }
                    else if (pseudoChildren[i].pseudoParent != this)
                    {
                        if (pseudoChildren[i].pseudoParent == null)
                            pseudoChildren[i].pseudoParent = this;
                        else
                            RemoveChild(pseudoChildren[i]);
                        CheckIfValid();
                        return;
                    }
                }
            }
            if (pseudoParent != null && !pseudoParent.pseudoChildren.Contains(this))
            {
                pseudoParent = null;
            }
        }

        private void OnTransformChanged()
        {

            CheckIfValid();
            PassOnTransformationToParent();
            PassOnTransformationToChildren();
        }
        public void PassOnTransformationToChildren(bool force = false)
        {
            if (!this.isActiveAndEnabled)
                return;
            if (pseudoChildren == null || pseudoChildren.Count == 0)
                return;
            foreach (BuildingUnit child in pseudoChildren)
            {
                if (!child.isActiveAndEnabled || !child.enableTransformationInheritance)
                    continue;
                OnPassOnTransformationToChild(child);
                child.CheckIfValid();
                if (child.TransformChanged() || force)
                {
                    child.PassOnTransformationToChildren(force);
                }
            }

        }
        public void PassOnTransformationToParent()
        {
            if (!this.isActiveAndEnabled || !enableTransformationInheritance)
                return;
            if (pseudoParent == null)
                return;

            if (IsRelatedInHierarchy())
            {
                pseudoParent.PassOnTransformationToChildren(true);
                return;
            }

            if (!pseudoParent.isActiveAndEnabled || !pseudoParent.enableTransformationInheritance)
            {
                return;
            }



            pseudoParent.OnInheritChildTransformation(this);
            CheckIfValid();

            if (pseudoParent != null)
            {
                pseudoParent.PassOnTransformationToParent();
            }
            else if (TransformChanged())
                PassOnTransformationToChildren();


        }

        public bool IsRelatedInHierarchy()
        {
            if (pseudoParent == null)
                return false;
            BuildingUnit garandPseudoParent = pseudoParent.pseudoParent;

            if (garandPseudoParent == null)
                return false;

            if (pseudoParent.transform.IsChildOf(garandPseudoParent.transform))
                return true;

            return pseudoParent.IsRelatedInHierarchy();
        }

        public virtual void OnPassOnTransformationToChild(BuildingUnit child)
        {
            if (!child.transform.IsChildOf(transform))
            {
                child.transform.localScale = transform.lossyScale;
            }


            child.transform.rotation = transform.rotation;
            child.transform.position = transform.position;
        }

        public virtual void OnInheritChildTransformation(BuildingUnit updatedChild)
        {
            if (!updatedChild.transform.IsChildOf(transform) && (pseudoParent != null && !transform.IsChildOf(pseudoParent.transform)))
            {
                transform.localScale = updatedChild.transform.lossyScale;
            }
            transform.rotation = updatedChild.transform.rotation;
            transform.position = updatedChild.transform.position;


        }



#endif
    }
}
