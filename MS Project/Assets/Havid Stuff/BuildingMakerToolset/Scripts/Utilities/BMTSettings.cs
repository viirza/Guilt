using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
namespace BuildingMakerToolset
{
    public class BMTSettings : ScriptableObject
    {
#if UNITY_EDITOR
        const string nameOfFile = "BMTSettings.asset";
        static BMTSettings _settingsBMT;
        public static BMTSettings SettingsBMT
        {
            get{
                if (_settingsBMT == null)
                {
                    _settingsBMT = (BMTSettings)AssetDatabase.LoadAssetAtPath(BHUtilities.ResourcePath + nameOfFile, typeof(BMTSettings));
                    if (_settingsBMT == null)
                    {
                        Debug.LogWarning(nameOfFile + " not found. creating a new one");
                        AssetDatabase.CreateAsset((BMTSettings)CreateInstance(typeof(BMTSettings)), BHUtilities.ResourcePath + nameOfFile);
                        _settingsBMT = (BMTSettings)AssetDatabase.LoadAssetAtPath(BHUtilities.ResourcePath + nameOfFile, typeof(BMTSettings));
                        if(_settingsBMT==null)
                            Debug.LogError(nameOfFile + " not found.");
                    }
                }
                return _settingsBMT;
            }
            
        }

        public PlatformShaperSettings platformShaperSettings;




        [System.Serializable]
        public class PlatformShaperSettings
        {
            [Header("PlatformShaper")]
            [SerializeField]float defaultScaleUV = 1;
            [SerializeField] Material defaultFaceUpMaterial;
            [SerializeField] Material defaultFaceDownMaterial;
            [SerializeField] Material defaultFaceSideMaterial;

            public static float ScaleUV
            {
                get
                {
                    if (SettingsBMT == null)
                        return 1;
                    return SettingsBMT.platformShaperSettings.defaultScaleUV;
                }
            }


            public static Material FaceUpMaterial
            {
                get
                {
                    if (SettingsBMT == null)
                        return null;
                    return SettingsBMT.platformShaperSettings.defaultFaceUpMaterial;
                }
            }

            public static Material FaceDownMaterial
            {
                get
                {
                    if (SettingsBMT == null)
                        return null;
                    return SettingsBMT.platformShaperSettings.defaultFaceDownMaterial;
                }
            }

            public static Material FaceSideMaterial
            {
                get
                {
                    if (SettingsBMT == null)
                        return null;
                    return SettingsBMT.platformShaperSettings.defaultFaceSideMaterial;
                }
            }
        }

#endif
    }
}
