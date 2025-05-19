﻿// Copyright (c) Jason Ma
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEditor;
using Object = UnityEngine.Object;

namespace LWGUI
{
	[CreateAssetMenu(fileName = "LWGUI_ShaderPropertyPreset.asset", menuName = "LWGUI/Shader Property Preset", order = 84)]
	public class ShaderPropertyPreset : ScriptableObject
	{
		public enum PropertyType
		{
			Color,
			Vector,
			Float,
			Range,
			Texture,
		}

		[Serializable]
		public class PropertyValue
		{
			public PropertyValue(MaterialProperty prop)
			{
				CopyFromMaterialProperty(prop);
			}

			public string       propertyName;
			public PropertyType propertyType;
			public float        floatValue;
			public Color        colorValue;
			public Vector4      vectorValue;
			public Texture      textureValue;

			private int propertyNameID = -1;

			public void Apply(Material material, bool isDefaultMaterial, PerMaterialData perMaterialData = null)
			{
				if (propertyNameID == -1 || !material.HasProperty(propertyNameID))
					propertyNameID = Shader.PropertyToID(propertyName);
				if (!material.HasProperty(propertyNameID))
				{
					// Legacy
					var propertyNameLower = propertyName.ToLower();
					switch (propertyNameLower)
					{
						case "renderqueue":
							material.renderQueue = (int)floatValue;
							return;
						default:
							// Debug.LogWarning("Unable to find Preset Property: " + propertyName + " in Material: " + material + "!");
							return;
					}
				}


				if (isDefaultMaterial)
				{
					switch (propertyType)
					{
						case PropertyType.Color:
							material.SetColor(propertyNameID, colorValue);
							break;
						case PropertyType.Vector:
							material.SetVector(propertyNameID, vectorValue);
							break;
						case PropertyType.Float:
						case PropertyType.Range:
							material.SetFloat(propertyNameID, floatValue);
							break;
						case PropertyType.Texture:
							material.SetTexture(propertyNameID, textureValue);
							break;
					}

					UnityEditorExtension.ApplyMaterialPropertyAndDecoratorDrawers(material);
				}
				// is Property Primary Material
				else if (perMaterialData != null)
				{
					var propDynamicData = perMaterialData.propDynamicDatas[propertyName];
					var prop = propDynamicData.property;
					switch (propertyType)
					{
						case PropertyType.Color:
							prop.colorValue = colorValue;
							break;
						case PropertyType.Vector:
							prop.vectorValue = vectorValue;
							break;
						case PropertyType.Float:
						case PropertyType.Range:
							prop.floatValue = floatValue;
							break;
						case PropertyType.Texture:
							prop.textureValue = textureValue;
							break;
					}

					propDynamicData.hasRevertChanged = true;
				}
			}

			public void CopyFromMaterialProperty(MaterialProperty prop)
			{
				propertyName = prop.name;
				switch (prop.type)
				{
					case MaterialProperty.PropType.Color:
						propertyType = PropertyType.Color;
						colorValue = prop.colorValue;
						break;
					case MaterialProperty.PropType.Vector:
						propertyType = PropertyType.Vector;
						vectorValue = prop.vectorValue;
						break;
					case MaterialProperty.PropType.Int:
					case MaterialProperty.PropType.Float:
						propertyType = PropertyType.Float;
						floatValue = prop.floatValue;
						break;
					case MaterialProperty.PropType.Range:   
						propertyType = PropertyType.Range;
						floatValue = prop.floatValue;
						break;
					case MaterialProperty.PropType.Texture: 
						propertyType = PropertyType.Texture;
						textureValue = prop.textureValue;
						break;
				}
			}

			public void OnValidate()
			{
				propertyNameID = -1;
			}
		}

		[Serializable]
		public class Preset
		{
			public string              presetName;
			public List<PropertyValue> propertyValues   = new List<PropertyValue>();
			public List<string>        enabledKeywords  = new List<string>();
			public List<string>        disabledKeywords = new List<string>();
			public List<string>        enabledPasses  = new List<string>();
			public List<string>        disabledPasses = new List<string>();
			public int                 renderQueue      = -1;


			public void ApplyToDefaultMaterial(Material material)
			{
				foreach (var propertyValue in propertyValues)
					propertyValue.Apply(material, true);
				foreach (var enabledKeyword in enabledKeywords)
					material.EnableKeyword(enabledKeyword);
				foreach (var disabledKeyword in disabledKeywords)
					material.DisableKeyword(disabledKeyword);
				
				Helper.SetShaderPassEnabled(new Object[] { material }, enabledPasses.Select(s => s.ToUpper()).ToArray(), true);
				Helper.SetShaderPassEnabled(new Object[] { material }, disabledPasses.Select(s => s.ToUpper()).ToArray(), false);
				
				if (renderQueue >= 0)
					material.renderQueue = renderQueue;
			}

			public void ApplyToEditingMaterial(Object[] materials, PerMaterialData perMaterialData)
			{
				for (int i = 0; i < materials.Length; i++)
				{
					var material = materials[i] as Material;
					foreach (var propertyValue in propertyValues)
						propertyValue.Apply(material, false, i == 0 ? perMaterialData : null);
					foreach (var enabledKeyword in enabledKeywords)
						material.EnableKeyword(enabledKeyword);
					foreach (var disabledKeyword in disabledKeywords)
						material.DisableKeyword(disabledKeyword);

					if (renderQueue >= 0)
						material.renderQueue = renderQueue;
				}
				
				Helper.SetShaderPassEnabled(materials, enabledPasses.Select(s => s.ToUpper()).ToArray(), true);
				Helper.SetShaderPassEnabled(materials, disabledPasses.Select(s => s.ToUpper()).ToArray(), false);
			}

			public void ApplyKeywordsAndPassesToMaterials(Object[] materials)
			{
				for (int i = 0; i < materials.Length; i++)
				{
					var material = materials[i] as Material;
					foreach (var enabledKeyword in enabledKeywords)
						material.EnableKeyword(enabledKeyword);
					foreach (var disabledKeyword in disabledKeywords)
						material.DisableKeyword(disabledKeyword);
				}
				
				Helper.SetShaderPassEnabled(materials, enabledPasses.Select(s => s.ToUpper()).ToArray(), true);
				Helper.SetShaderPassEnabled(materials, disabledPasses.Select(s => s.ToUpper()).ToArray(), false);
			}

			public PropertyValue GetPropertyValue(string propName)
			{
				PropertyValue result = null;
				if (propertyValues != null)
				{
					foreach (var propertyValue in propertyValues)
					{
						if (propertyValue.propertyName == propName)
						{
							result = propertyValue;
							break;
						}
					}
				}
				return result;
			}

			public void AddOrUpdate(MaterialProperty prop)
			{
				var propertyValue = GetPropertyValue(prop.name);
				if (propertyValue != null)
					propertyValue.CopyFromMaterialProperty(prop);
				else
					propertyValues.Add(new PropertyValue(prop));
			}

			public void AddOrUpdateIncludeExtraProperties(LWGUIMetaDatas metaDatas, MaterialProperty prop)
			{
				AddOrUpdate(prop);
				foreach (var extraPropName in metaDatas.GetPropStaticData(prop).extraPropNames)
				{
					AddOrUpdate(metaDatas.GetProperty(extraPropName));
				}
			}

			public void Remove(string propName)
			{
				var propertyValue = GetPropertyValue(propName);
				if (propertyValue != null)
					propertyValues.Remove(propertyValue);
			}

			public void RemoveIncludeExtraProperties(LWGUIMetaDatas metaDatas, string propName)
			{
				Remove(propName);
				foreach (var extraPropName in metaDatas.GetPropStaticData(propName).extraPropNames)
				{
					Remove(metaDatas.GetProperty(extraPropName).name);
				}
			}
		}


		public List<Preset> presets;

		
		private void OnValidate()
		{
			// Update All Material Default Values
			MetaDataHelper.ReleaseAllShadersMetadataCache();
		}
		
		private void OnEnable()
		{
			if (PresetHelper.IsInitComplete)
				PresetHelper.AddPreset(this);
		}
	}
}