﻿// Copyright (c) Jason Ma

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace LWGUI
{
    public static class ReflectionHelper
    {
        #region MaterialPropertyHandler

        private static readonly Type MaterialPropertyHandler_Type = Assembly.GetAssembly(typeof(Editor)).GetType("UnityEditor.MaterialPropertyHandler");
        private static readonly MethodInfo MaterialPropertyHandler_GetHandler_Method = MaterialPropertyHandler_Type.GetMethod("GetHandler", BindingFlags.Static | BindingFlags.NonPublic);
        private static readonly PropertyInfo MaterialPropertyHandler_PropertyDrawer_Property = MaterialPropertyHandler_Type.GetProperty("propertyDrawer");
        private static readonly FieldInfo MaterialPropertyHandler_DecoratorDrawers_Field = MaterialPropertyHandler_Type.GetField("m_DecoratorDrawers", BindingFlags.NonPublic | BindingFlags.Instance);

        public static MaterialPropertyDrawer GetPropertyDrawer(Shader shader, MaterialProperty prop, out List<MaterialPropertyDrawer> decoratorDrawers)
        {
            decoratorDrawers = new List<MaterialPropertyDrawer>();
            var handler = MaterialPropertyHandler_GetHandler_Method.Invoke(null, new object[] { shader, prop.name });
            if (handler != null && handler.GetType() == MaterialPropertyHandler_Type)
            {
                decoratorDrawers = MaterialPropertyHandler_DecoratorDrawers_Field.GetValue(handler) as List<MaterialPropertyDrawer>;
                return MaterialPropertyHandler_PropertyDrawer_Property.GetValue(handler, null) as MaterialPropertyDrawer;
            }

            return null;
        }

        public static MaterialPropertyDrawer GetPropertyDrawer(Shader shader, MaterialProperty prop)
        {
            return GetPropertyDrawer(shader, prop, out _);
        }

        #endregion


        #region MaterialEditor

        public static float DoPowerRangeProperty(Rect position, MaterialProperty prop, GUIContent label, float power)
        {
            return MaterialEditor.DoPowerRangeProperty(position, prop, label, power);
        }

        public static void DefaultShaderPropertyInternal(this MaterialEditor editor, Rect position, MaterialProperty prop, GUIContent label)
        {
            editor.DefaultShaderPropertyInternal(position, prop, label);
        }

        public static List<Renderer> GetMeshRenderersByMaterialEditor(this MaterialEditor materialEditor)
        {
            var outRenderers = new List<Renderer>();

            // MaterialEditor.ShouldEditorBeHidden()
            PropertyEditor property = materialEditor.propertyViewer as PropertyEditor;
            if (property)
            {
                GameObject gameObject = property.tracker.activeEditors[0].target as GameObject;
                if (gameObject)
                {
                    outRenderers.AddRange(gameObject.GetComponents<MeshRenderer>());
                    outRenderers.AddRange(gameObject.GetComponents<SkinnedMeshRenderer>());
                }
            }

            return outRenderers;
        }

        #endregion


        #region EditorUtility

        public static void DisplayCustomMenuWithSeparators(Rect position, string[] options, bool[] enabled, bool[] separator, int[] selected, EditorUtility.SelectMenuItemFunction callback, object userData = null, bool showHotkey = false)
        {
            EditorUtility.DisplayCustomMenuWithSeparators(position, options, enabled, separator, selected, callback, userData, showHotkey);
        }

        #endregion


        #region EditorGUI

        public static float EditorGUI_Indent => EditorGUI.indentLevel;

        #endregion

        #region EditorGUILayout

        public static float EditorGUILayout_kLabelFloatMinW => EditorGUILayout.kLabelFloatMinW;

        #endregion


        #region MaterialEnumDrawer

        // UnityEditor.MaterialEnumDrawer(string enumName)
        private static Type[] _types;

        public static Type[] GetAllTypes()
        {
            if (_types == null)
            {
                _types = AppDomain.CurrentDomain.GetAssemblies()
                    .SelectMany(assembly =>
                    {
                        if (assembly == null)
                            return Type.EmptyTypes;
                        try
                        {
                            return assembly.GetTypes();
                        }
                        catch (ReflectionTypeLoadException ex)
                        {
                            Debug.LogError(ex);
                            return Type.EmptyTypes;
                        }
                    }).ToArray();
            }

            return _types;
        }

        #endregion


        #region MaterialProperty.PropertyData

#if UNITY_2022_1_OR_NEWER
        private static readonly Type MaterialProperty_Type = typeof(MaterialProperty);
        private static readonly Type PropertyData_Type = MaterialProperty_Type.GetNestedType("PropertyData", BindingFlags.NonPublic);
        private static readonly MethodInfo PropertyData_MergeStack_Method = PropertyData_Type.GetMethod("MergeStack", BindingFlags.Static | BindingFlags.NonPublic);
        private static readonly MethodInfo PropertyData_HandleApplyRevert_Method = PropertyData_Type.GetMethod("HandleApplyRevert", BindingFlags.Static | BindingFlags.NonPublic);

        public static void HandleApplyRevert(GenericMenu menu, MaterialProperty prop)
        {
            var parameters = new object[3];
            PropertyData_MergeStack_Method.Invoke(null, parameters);
            var overriden = (bool)parameters[2];
            var singleEditing = prop.targets.Length == 1;

            if (overriden)
            {
                PropertyData_HandleApplyRevert_Method.Invoke(null, new object[] { menu, singleEditing, prop.targets });
                menu.AddSeparator("");
            }
        }
#endif

        #endregion

        #region GUI

        private static readonly MethodInfo gui_Button_Method = typeof(GUI).GetMethod("Button", BindingFlags.Static | BindingFlags.NonPublic);

        public static bool GUI_Button(Rect position, int id, GUIContent content, GUIStyle style)
        {
            return (bool)gui_Button_Method.Invoke(null, new object[] { position, id, content, style });
        }

        #endregion

        #region GradientEditor

        private static readonly FieldInfo k_MaxNumKeys_Field = typeof(GradientEditor).GetField("k_MaxNumKeys", BindingFlags.Static | BindingFlags.NonPublic);
        public static readonly int maxGradientKeyCount = (int)k_MaxNumKeys_Field.GetValue(null);


        private static readonly FieldInfo m_SelectedSwatch_Field = typeof(GradientEditor).GetField("m_SelectedSwatch", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static GradientEditor.Swatch GetSelectedSwatch(this GradientEditor gradientEditor)
        {
            return m_SelectedSwatch_Field.GetValue(gradientEditor) as GradientEditor.Swatch;
        }

        internal static void SetSelectedSwatch(this GradientEditor gradientEditor, GradientEditor.Swatch swatch)
        {
            m_SelectedSwatch_Field.SetValue(gradientEditor, swatch);
        }


        private static readonly FieldInfo m_RGBSwatches_Field = typeof(GradientEditor).GetField("m_RGBSwatches", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static List<GradientEditor.Swatch> GetRGBdSwatches(this GradientEditor gradientEditor)
        {
            return m_RGBSwatches_Field.GetValue(gradientEditor) as List<GradientEditor.Swatch>;
        }


        private static readonly FieldInfo m_AlphaSwatches_Field = typeof(GradientEditor).GetField("m_AlphaSwatches", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static List<GradientEditor.Swatch> GetAlphaSwatches(this GradientEditor gradientEditor)
        {
            return m_AlphaSwatches_Field.GetValue(gradientEditor) as List<GradientEditor.Swatch>;
        }


        private static object s_Styles_Value;
        private static readonly FieldInfo s_Styles_Field = typeof(GradientEditor).GetField("s_Styles", BindingFlags.Static | BindingFlags.NonPublic);
        public static void GradientEditor_SetStyles()
        {
            s_Styles_Value ??= Activator.CreateInstance(typeof(GradientEditor).GetNestedType("Styles", BindingFlags.NonPublic));
            s_Styles_Field.SetValue(null, s_Styles_Value);
        }


        private static readonly MethodInfo ShowSwatchArray_Method = typeof(GradientEditor)
            .GetMethod("ShowSwatchArray", BindingFlags.Instance | BindingFlags.NonPublic, null, new[] { typeof(Rect), typeof(List<GradientEditor.Swatch>), typeof(bool) }, null);

        internal static void ShowSwatchArray(this GradientEditor gradientEditor, Rect position, List<GradientEditor.Swatch> swatches, bool isAlpha)
        {
            ShowSwatchArray_Method.Invoke(gradientEditor, new object[] { position, swatches, isAlpha });
        }


        private static readonly MethodInfo GetTime_Method = typeof(GradientEditor).GetMethod("GetTime", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static float GetTime(this GradientEditor gradientEditor, float actualTime)
        {
            return (float)GetTime_Method.Invoke(gradientEditor, new object[] { actualTime });
        }

        #endregion

        #region CurveEditor

        private static readonly FieldInfo m_CurveEditor_Field = typeof(CurveEditorWindow).GetField("m_CurveEditor", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static CurveEditor GetCurveEditor(this CurveEditorWindow curveEditorWindow)
        {
            return m_CurveEditor_Field.GetValue(curveEditorWindow) as CurveEditor;
        }


        private static readonly MethodInfo AddKeyAtTime_Method = typeof(CurveEditor).GetMethod("AddKeyAtTime", BindingFlags.Instance | BindingFlags.NonPublic);
        internal static CurveSelection AddKeyAtTime(this CurveEditor curveEditor, CurveWrapper cw, float time)
        {
            return AddKeyAtTime_Method.Invoke(curveEditor, new object[] { cw, time }) as CurveSelection;
        }

        #endregion
    }
}