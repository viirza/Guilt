using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace BuildingMakerToolset {
#if UNITY_EDITOR
	[InitializeOnLoad]
    public class BMTLoad
    {
		static BMTLoad()
        {
			DisableGizmosIcon();
		}

		static void DisableGizmosIcon()
		{
#if UNITY_EDITOR && UNITY_2022_1_OR_NEWER
			GizmoUtility.SetIconEnabled(typeof(PropPlacer.RowPropPlacer), false);
			GizmoUtility.SetIconEnabled(typeof(PropPlacer.PropSwapper), false);
			GizmoUtility.SetIconEnabled(typeof(PropPlacer.PropSwapperHelper), false);
			GizmoUtility.SetIconEnabled(typeof(PlatformMaker.FootPrintMaker), false);
#endif
		}
	}
#endif
}
