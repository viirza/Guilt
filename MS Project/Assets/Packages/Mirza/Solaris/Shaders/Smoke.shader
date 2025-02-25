// Made with Amplify Shader Editor v1.9.7.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mirza/Smoke"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HDR][Header(Colour)][Space(5)]_Colour("Colour", Color) = (1,1,1,1)
		_AlphaErosion("Alpha Erosion", Range( 0 , 1)) = 0
		_ParticleAlphaErosionoverLifetime("Particle Alpha Erosion over Lifetime", Range( 0 , 1)) = 0
		[Header(Texture)][Space(5)]_BaseMap("Base Map", 2D) = "white" {}
		_BaseAlpha("Base Alpha", Range( 0 , 1)) = 1
		_BaseAlphaPower("Base Alpha Power", Range( 0.5 , 2)) = 1
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalMapScale("Normal Map Scale", Float) = 1
		[Header(Depth Fade)][Space(5)]_DepthFade("Depth Fade", Float) = 0
		_DepthFadePower("Depth Fade Power", Float) = 1
		[Header(Camera Depth Fade)][Space(5)]_CameraDepthFadeLength("Camera Depth Fade Length", Float) = 0
		_CameraDepthFadeOffset("Camera Depth Fade Offset", Float) = 0
		_CameraDepthFadePower("Camera Depth Fade Power", Float) = 1
		[Header(Particle Settings)][Space(5)]_ParticleRandomization("Particle Randomization", Range( 0 , 1)) = 1
		[Header(Lighting)][Space(5)][Toggle(_LIGHTINGENABLED_ON)] _LightingEnabled("Lighting Enabled", Float) = 0
		[Space(5)]_MainLight("Main Light", Range( 0 , 1)) = 1
		[Space(5)]_AdditionalLights("Additional Lights", Range( 0 , 1)) = 1
		_AdditionalLightsTranslucency("Additional Lights Translucency", Range( 0 , 8)) = 1
		[Space(5)][Toggle(_ADDITIONALLIGHTSTRANSLUCENCYENABLED_ON)] _AdditionalLightsTranslucencyEnabled("Additional Lights Translucency Enabled", Float) = 0
		[Header(Additive Noise)][Space(5)]_AdditiveNoise("Additive Noise", Range( 0 , 2)) = 1
		[Toggle(_ADDITIVENOISEENABLED_ON)] _AdditiveNoiseEnabled("Additive Noise Enabled", Float) = 1
		_AdditiveNoiseScale("Additive Noise Scale", Float) = 40
		_AdditiveNoiseAnimation("Additive Noise Animation", Vector) = (0,0,0,0)
		_AdditiveNoiseOffset("Additive Noise Offset", Vector) = (0,0,0,0)
		_AdditiveNoisePower("Additive Noise Power", Float) = 1
		_AdditiveNoisetoRGB("Additive Noise to RGB", Range( 0 , 1)) = 0
		[Space(5)]_AdditiveNoiseNormalfromHeight("Additive Noise Normal from Height", Float) = 0
		[Header(Subtractive Noise)][Space(5)]_SubtractiveNoise("Subtractive Noise", Range( 0 , 1)) = 0
		[Toggle(_SUBTRACTIVENOISEENABLED_ON)] _SubtractiveNoiseEnabled("Subtractive Noise Enabled", Float) = 0
		_SubtractiveNoiseScale("Subtractive Noise Scale", Float) = 40
		_SubtractiveNoiseAnimation("Subtractive Noise Animation", Vector) = (0,0,0,0)
		_SubtractiveNoiseOffset("Subtractive Noise Offset", Vector) = (0,0,0,0)
		_SubtractiveNoisePower("Subtractive Noise Power", Float) = 1
		[Header(Distortion Noise)][Space(5)]_DistortionNoise("Distortion Noise", Range( 0 , 0.1)) = 0
		[Toggle(_DISTORTIONNOISEENABLED_ON)] _DistortionNoiseEnabled("Distortion Noise Enabled", Float) = 1
		_DistortionNoiseScale("Distortion Noise Scale", Float) = 2
		_DistortionNoiseAnimation("Distortion Noise Animation", Vector) = (0,0,0,0)
		_DistortionNoiseOffset("Distortion Noise Offset", Vector) = (0,0,0,0)
		[IntRange]_DistortionNoiseOctaves("Distortion Noise Octaves", Range( 1 , 8)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "UniversalMaterialType"="Unlit" }

		Cull Off
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForwardOnly" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			

			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_VERSION 19701
			#define ASE_SRP_VERSION 140011
			#define REQUIRE_DEPTH_TEXTURE 1


			

			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3

			

			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_UNLIT

			
            #if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#endif
		

			
			#if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#endif
		

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			
			#if ASE_SRP_VERSION >=140010
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#endif
		

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging3D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceData.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#include "../../VFXToolkit/Shaders/_Includes/Noise.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _LIGHTINGENABLED_ON
			#pragma shader_feature_local _DISTORTIONNOISEENABLED_ON
			#pragma shader_feature_local _ADDITIVENOISEENABLED_ON
			#pragma shader_feature_local _ADDITIONALLIGHTSTRANSLUCENCYENABLED_ON
			#pragma shader_feature_local _SUBTRACTIVENOISEENABLED_ON
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _FORWARD_PLUS
			#pragma multi_compile _ _LIGHT_LAYERS


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 positionWS : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD2;
				#endif
				#ifdef ASE_FOG
					float fogFactor : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_color : COLOR;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DistortionNoiseOffset;
			float4 _DistortionNoiseAnimation;
			float4 _NormalMap_ST;
			float4 _AdditiveNoiseOffset;
			float4 _AdditiveNoiseAnimation;
			float4 _Colour;
			float4 _SubtractiveNoiseAnimation;
			float4 _SubtractiveNoiseOffset;
			float _DistortionNoiseScale;
			float _AlphaErosion;
			float _ParticleAlphaErosionoverLifetime;
			float _SubtractiveNoiseScale;
			float _SubtractiveNoisePower;
			float _SubtractiveNoise;
			float _DepthFade;
			float _DepthFadePower;
			float _CameraDepthFadeLength;
			float _BaseAlpha;
			float _BaseAlphaPower;
			float _AdditiveNoiseNormalfromHeight;
			float _AdditionalLightsTranslucency;
			float _CameraDepthFadeOffset;
			float _NormalMapScale;
			float _MainLight;
			float _AdditiveNoisetoRGB;
			float _AdditiveNoise;
			float _AdditiveNoisePower;
			float _AdditiveNoiseScale;
			float _DistortionNoise;
			float _DistortionNoiseOctaves;
			float _ParticleRandomization;
			float _AdditionalLights;
			float _CameraDepthFadePower;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _BaseMap;
			sampler2D _NormalMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			
			float3 PerturbNormal107_g308( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			half4 CalculateShadowMask216_g305(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 AdditionalLightsLambertMask14x( float3 WorldPosition, float2 ScreenUV, float3 WorldNormal, float4 ShadowMask )
			{
				float3 Color = 0;
				#if defined(_ADDITIONAL_LIGHTS)
					#define SUM_LIGHTLAMBERT(Light)\
						half3 AttLightColor = Light.color * ( Light.distanceAttenuation * Light.shadowAttenuation );\
						Color += LightingLambert( AttLightColor, Light.direction, WorldNormal );
					InputData inputData = (InputData)0;
					inputData.normalizedScreenSpaceUV = ScreenUV;
					inputData.positionWS = WorldPosition;
					uint meshRenderingLayers = GetMeshRenderingLayer();
					uint pixelLightCount = GetAdditionalLightsCount();	
					#if USE_FORWARD_PLUS
					for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
					{
						FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					}
					#endif
					
					LIGHT_LOOP_BEGIN( pixelLightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition, ShadowMask);
						#ifdef _LIGHT_LAYERS
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						#endif
						{
							SUM_LIGHTLAMBERT( light );
						}
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			float3 PerturbNormal107_g307( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			half4 CalculateShadowMask216_g302(  )
			{
				#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
				half4 shadowMask = inputData.shadowMask;
				#elif !defined (LIGHTMAP_ON)
				half4 shadowMask = unity_ProbesOcclusion;
				#else
				half4 shadowMask = half4(1, 1, 1, 1);
				#endif
				return shadowMask;
			}
			
			float3 ASESafeNormalize(float3 inVec)
			{
				float dp3 = max(1.175494351e-38, dot(inVec, inVec));
				return inVec* rsqrt(dp3);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.normalOS);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord7.xyz = ase_worldTangent;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord8.xyz = ase_worldBitangent;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.positionOS.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord6.w = eyeDepth;
				
				o.ase_texcoord4 = v.ase_texcoord;
				o.ase_texcoord5 = v.positionOS;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.w = 0;
				o.ase_texcoord8.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = v.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = vertexInput.positionWS;
				#endif

				#ifdef ASE_FOG
					o.fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN
				#ifdef _WRITE_RENDERING_LAYERS
				, out float4 outRenderingLayers : SV_Target1
				#endif
				 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 texCoord244 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float localSimplexNoise_float2_g297 = ( 0.0 );
				float Particle_Stable_Random157 = ( ( IN.ase_texcoord4.w - 0.5 ) * 100.0 * _ParticleRandomization );
				float4 temp_output_10_0_g295 = ( float4( ( IN.ase_texcoord5.xyz * _DistortionNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _DistortionNoiseOffset + Particle_Stable_Random157 ) + ( _DistortionNoiseAnimation * _TimeParameters.x ) ) );
				float3 position2_g297 = (temp_output_10_0_g295).xyz;
				float angle2_g297 = (temp_output_10_0_g295).w;
				float octaves2_g297 = _DistortionNoiseOctaves;
				float noise2_g297 = 0.0;
				float3 gradient2_g297 = float3( 0,0,0 );
				SimplexNoise_float( position2_g297 , angle2_g297 , octaves2_g297 , noise2_g297 , gradient2_g297 );
				#ifdef _DISTORTIONNOISEENABLED_ON
				float3 staticSwitch233 = ( gradient2_g297 * _DistortionNoise );
				#else
				float3 staticSwitch233 = float3( 0,0,0 );
				#endif
				float3 Distortion_Noise234 = staticSwitch233;
				float4 tex2DNode10 = tex2D( _BaseMap, ( float3( texCoord244 ,  0.0 ) + Distortion_Noise234 ).xy );
				float4 temp_output_10_0_g288 = ( float4( ( IN.ase_texcoord5.xyz * _AdditiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _AdditiveNoiseOffset + Particle_Stable_Random157 ) + ( _AdditiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_154_0 = (temp_output_10_0_g288).xyz;
				float simpleNoise175 = SimpleNoise( temp_output_154_0.xy );
				#ifdef _ADDITIVENOISEENABLED_ON
				float staticSwitch176 = ( pow( simpleNoise175 , _AdditiveNoisePower ) * _AdditiveNoise );
				#else
				float staticSwitch176 = 0.0;
				#endif
				float Additive_Noise155 = staticSwitch176;
				float4 temp_output_40_0 = ( ( tex2DNode10 + ( Additive_Noise155 * _AdditiveNoisetoRGB * float4(1,1,1,0) ) ) * IN.ase_color * _Colour );
				float3 Coloured_Base_RGB48 = (temp_output_40_0).rgb;
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b );
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float3 worldPosValue184_g305 = WorldPosition;
				float3 WorldPosition136_g305 = worldPosValue184_g305;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 ScreenUV183_g305 = (ase_screenPosNorm).xy;
				float2 ScreenUV136_g305 = ScreenUV183_g305;
				float2 uv_NormalMap = IN.ase_texcoord4.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				float3 unpack123 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap ), _NormalMapScale );
				unpack123.z = lerp( 1, unpack123.z, saturate(_NormalMapScale) );
				float3 tex2DNode123 = unpack123;
				float3 Normal_Map125 = tex2DNode123;
				float3 surf_pos107_g308 = WorldPosition;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 surf_norm107_g308 = ase_worldNormal;
				float height107_g308 = Additive_Noise155;
				float scale107_g308 = _AdditiveNoiseNormalfromHeight;
				float3 localPerturbNormal107_g308 = PerturbNormal107_g308( surf_pos107_g308 , surf_norm107_g308 , height107_g308 , scale107_g308 );
				float3 ase_worldTangent = IN.ase_texcoord7.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord8.xyz;
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3 worldToTangentDir42_g308 = mul( ase_worldToTangent, localPerturbNormal107_g308);
				#ifdef _ADDITIVENOISEENABLED_ON
				float3 staticSwitch203 = BlendNormal( worldToTangentDir42_g308 , Normal_Map125 );
				#else
				float3 staticSwitch203 = Normal_Map125;
				#endif
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal12_g305 = staticSwitch203;
				float3 worldNormal12_g305 = normalize( float3(dot(tanToWorld0,tanNormal12_g305), dot(tanToWorld1,tanNormal12_g305), dot(tanToWorld2,tanNormal12_g305)) );
				float3 worldNormalValue185_g305 = worldNormal12_g305;
				float3 WorldNormal136_g305 = worldNormalValue185_g305;
				half4 localCalculateShadowMask216_g305 = CalculateShadowMask216_g305();
				float4 shadowMaskValue182_g305 = localCalculateShadowMask216_g305;
				float4 ShadowMask136_g305 = shadowMaskValue182_g305;
				float3 localAdditionalLightsLambertMask14x136_g305 = AdditionalLightsLambertMask14x( WorldPosition136_g305 , ScreenUV136_g305 , WorldNormal136_g305 , ShadowMask136_g305 );
				float3 temp_output_87_0 = localAdditionalLightsLambertMask14x136_g305;
				float3 worldPosValue184_g302 = WorldPosition;
				float3 WorldPosition136_g302 = worldPosValue184_g302;
				float2 ScreenUV183_g302 = (ase_screenPosNorm).xy;
				float2 ScreenUV136_g302 = ScreenUV183_g302;
				float3 Negative_Normal_Map208 = -tex2DNode123;
				float3 surf_pos107_g307 = WorldPosition;
				float3 surf_norm107_g307 = ase_worldNormal;
				float height107_g307 = ( ( 1.0 - Additive_Noise155 ) * 0.5 );
				float scale107_g307 = _AdditiveNoiseNormalfromHeight;
				float3 localPerturbNormal107_g307 = PerturbNormal107_g307( surf_pos107_g307 , surf_norm107_g307 , height107_g307 , scale107_g307 );
				float3 worldToTangentDir42_g307 = mul( ase_worldToTangent, localPerturbNormal107_g307);
				#ifdef _ADDITIVENOISEENABLED_ON
				float3 staticSwitch205 = BlendNormal( worldToTangentDir42_g307 , Negative_Normal_Map208 );
				#else
				float3 staticSwitch205 = Negative_Normal_Map208;
				#endif
				float3 tanNormal12_g302 = staticSwitch205;
				float3 worldNormal12_g302 = normalize( float3(dot(tanToWorld0,tanNormal12_g302), dot(tanToWorld1,tanNormal12_g302), dot(tanToWorld2,tanNormal12_g302)) );
				float3 worldNormalValue185_g302 = worldNormal12_g302;
				float3 WorldNormal136_g302 = worldNormalValue185_g302;
				half4 localCalculateShadowMask216_g302 = CalculateShadowMask216_g302();
				float4 shadowMaskValue182_g302 = localCalculateShadowMask216_g302;
				float4 ShadowMask136_g302 = shadowMaskValue182_g302;
				float3 localAdditionalLightsLambertMask14x136_g302 = AdditionalLightsLambertMask14x( WorldPosition136_g302 , ScreenUV136_g302 , WorldNormal136_g302 , ShadowMask136_g302 );
				float3 temp_output_88_0 = localAdditionalLightsLambertMask14x136_g302;
				float3 normalizeResult98 = ASESafeNormalize( temp_output_88_0 );
				float Base_R115 = ( tex2DNode10.r + Additive_Noise155 );
				#ifdef _ADDITIONALLIGHTSTRANSLUCENCYENABLED_ON
				float3 staticSwitch109 = ( temp_output_87_0 + ( normalizeResult98 * length( temp_output_88_0 ) * ( Base_R115 * _AdditionalLightsTranslucency ) ) );
				#else
				float3 staticSwitch109 = temp_output_87_0;
				#endif
				float3 Additional_Lights113 = ( staticSwitch109 * _AdditionalLights );
				float3 Lighting96 = ( ( ase_lightColor.rgb * ase_lightColor.a * _MainLight ) + Additional_Lights113 );
				#ifdef _LIGHTINGENABLED_ON
				float3 staticSwitch119 = ( Coloured_Base_RGB48 + Lighting96 );
				#else
				float3 staticSwitch119 = Coloured_Base_RGB48;
				#endif
				float3 Colour86 = staticSwitch119;
				
				float Coloured_Base_Alpha47 = (temp_output_40_0).a;
				float Particle_Alpha_Erosion_over_Lifetime135 = ( IN.ase_texcoord4.z * _ParticleAlphaErosionoverLifetime );
				float4 temp_output_10_0_g298 = ( float4( ( IN.ase_texcoord5.xyz * _SubtractiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _SubtractiveNoiseOffset + Particle_Stable_Random157 ) + ( _SubtractiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_187_0 = (temp_output_10_0_g298).xyz;
				float simpleNoise196 = SimpleNoise( temp_output_187_0.xy );
				#ifdef _SUBTRACTIVENOISEENABLED_ON
				float staticSwitch192 = ( pow( simpleNoise196 , _SubtractiveNoisePower ) * _SubtractiveNoise );
				#else
				float staticSwitch192 = 0.0;
				#endif
				float Subtractive_Noise193 = staticSwitch192;
				float temp_output_7_0_g300 = 0.0;
				float temp_output_23_0_g300 = 1.0;
				float screenDepth14 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthFade ) ) );
				float temp_output_20_0_g300 = distanceDepth14;
				float temp_output_4_0_g300 = _DepthFadePower;
				float smoothstepResult22_g300 = smoothstep( temp_output_7_0_g300 , temp_output_23_0_g300 , pow( temp_output_20_0_g300 , temp_output_4_0_g300 ));
				float Depth_Fade143 = smoothstepResult22_g300;
				float temp_output_7_0_g301 = 0.0;
				float temp_output_23_0_g301 = 1.0;
				float eyeDepth = IN.ase_texcoord6.w;
				float cameraDepthFade148 = (( eyeDepth -_ProjectionParams.y - _CameraDepthFadeOffset ) / _CameraDepthFadeLength);
				float temp_output_20_0_g301 = cameraDepthFade148;
				float temp_output_4_0_g301 = _CameraDepthFadePower;
				float smoothstepResult22_g301 = smoothstep( temp_output_7_0_g301 , temp_output_23_0_g301 , pow( temp_output_20_0_g301 , temp_output_4_0_g301 ));
				float Camera_Depth_Fade151 = smoothstepResult22_g301;
				float Alpha51 = ( saturate( ( ( ( ( pow( Coloured_Base_Alpha47 , _BaseAlphaPower ) * _BaseAlpha ) + ( Additive_Noise155 * Coloured_Base_Alpha47 ) ) - ( _AlphaErosion + Particle_Alpha_Erosion_over_Lifetime135 ) ) - Subtractive_Noise193 ) ) * Depth_Fade143 * Camera_Depth_Fade151 );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = Colour86;
				float Alpha = Alpha51;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToBaseColor(IN.positionCS, Color);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				return half4( Color, Alpha );
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			

			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_VERSION 19701
			#define ASE_SRP_VERSION 140011
			#define REQUIRE_DEPTH_TEXTURE 1


			

			#pragma vertex vert
			#pragma fragment frag

			
            #if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#endif
		

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#include "../../VFXToolkit/Shaders/_Includes/Noise.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _DISTORTIONNOISEENABLED_ON
			#pragma shader_feature_local _ADDITIVENOISEENABLED_ON
			#pragma shader_feature_local _SUBTRACTIVENOISEENABLED_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 positionWS : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DistortionNoiseOffset;
			float4 _DistortionNoiseAnimation;
			float4 _NormalMap_ST;
			float4 _AdditiveNoiseOffset;
			float4 _AdditiveNoiseAnimation;
			float4 _Colour;
			float4 _SubtractiveNoiseAnimation;
			float4 _SubtractiveNoiseOffset;
			float _DistortionNoiseScale;
			float _AlphaErosion;
			float _ParticleAlphaErosionoverLifetime;
			float _SubtractiveNoiseScale;
			float _SubtractiveNoisePower;
			float _SubtractiveNoise;
			float _DepthFade;
			float _DepthFadePower;
			float _CameraDepthFadeLength;
			float _BaseAlpha;
			float _BaseAlphaPower;
			float _AdditiveNoiseNormalfromHeight;
			float _AdditionalLightsTranslucency;
			float _CameraDepthFadeOffset;
			float _NormalMapScale;
			float _MainLight;
			float _AdditiveNoisetoRGB;
			float _AdditiveNoise;
			float _AdditiveNoisePower;
			float _AdditiveNoiseScale;
			float _DistortionNoise;
			float _DistortionNoiseOctaves;
			float _ParticleRandomization;
			float _AdditionalLights;
			float _CameraDepthFadePower;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _BaseMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.positionOS.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.x = eyeDepth;
				
				o.ase_texcoord3 = v.ase_texcoord;
				o.ase_texcoord4 = v.positionOS;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = v.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = vertexInput.positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 texCoord244 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float localSimplexNoise_float2_g297 = ( 0.0 );
				float Particle_Stable_Random157 = ( ( IN.ase_texcoord3.w - 0.5 ) * 100.0 * _ParticleRandomization );
				float4 temp_output_10_0_g295 = ( float4( ( IN.ase_texcoord4.xyz * _DistortionNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _DistortionNoiseOffset + Particle_Stable_Random157 ) + ( _DistortionNoiseAnimation * _TimeParameters.x ) ) );
				float3 position2_g297 = (temp_output_10_0_g295).xyz;
				float angle2_g297 = (temp_output_10_0_g295).w;
				float octaves2_g297 = _DistortionNoiseOctaves;
				float noise2_g297 = 0.0;
				float3 gradient2_g297 = float3( 0,0,0 );
				SimplexNoise_float( position2_g297 , angle2_g297 , octaves2_g297 , noise2_g297 , gradient2_g297 );
				#ifdef _DISTORTIONNOISEENABLED_ON
				float3 staticSwitch233 = ( gradient2_g297 * _DistortionNoise );
				#else
				float3 staticSwitch233 = float3( 0,0,0 );
				#endif
				float3 Distortion_Noise234 = staticSwitch233;
				float4 tex2DNode10 = tex2D( _BaseMap, ( float3( texCoord244 ,  0.0 ) + Distortion_Noise234 ).xy );
				float4 temp_output_10_0_g288 = ( float4( ( IN.ase_texcoord4.xyz * _AdditiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _AdditiveNoiseOffset + Particle_Stable_Random157 ) + ( _AdditiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_154_0 = (temp_output_10_0_g288).xyz;
				float simpleNoise175 = SimpleNoise( temp_output_154_0.xy );
				#ifdef _ADDITIVENOISEENABLED_ON
				float staticSwitch176 = ( pow( simpleNoise175 , _AdditiveNoisePower ) * _AdditiveNoise );
				#else
				float staticSwitch176 = 0.0;
				#endif
				float Additive_Noise155 = staticSwitch176;
				float4 temp_output_40_0 = ( ( tex2DNode10 + ( Additive_Noise155 * _AdditiveNoisetoRGB * float4(1,1,1,0) ) ) * IN.ase_color * _Colour );
				float Coloured_Base_Alpha47 = (temp_output_40_0).a;
				float Particle_Alpha_Erosion_over_Lifetime135 = ( IN.ase_texcoord3.z * _ParticleAlphaErosionoverLifetime );
				float4 temp_output_10_0_g298 = ( float4( ( IN.ase_texcoord4.xyz * _SubtractiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _SubtractiveNoiseOffset + Particle_Stable_Random157 ) + ( _SubtractiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_187_0 = (temp_output_10_0_g298).xyz;
				float simpleNoise196 = SimpleNoise( temp_output_187_0.xy );
				#ifdef _SUBTRACTIVENOISEENABLED_ON
				float staticSwitch192 = ( pow( simpleNoise196 , _SubtractiveNoisePower ) * _SubtractiveNoise );
				#else
				float staticSwitch192 = 0.0;
				#endif
				float Subtractive_Noise193 = staticSwitch192;
				float temp_output_7_0_g300 = 0.0;
				float temp_output_23_0_g300 = 1.0;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth14 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthFade ) ) );
				float temp_output_20_0_g300 = distanceDepth14;
				float temp_output_4_0_g300 = _DepthFadePower;
				float smoothstepResult22_g300 = smoothstep( temp_output_7_0_g300 , temp_output_23_0_g300 , pow( temp_output_20_0_g300 , temp_output_4_0_g300 ));
				float Depth_Fade143 = smoothstepResult22_g300;
				float temp_output_7_0_g301 = 0.0;
				float temp_output_23_0_g301 = 1.0;
				float eyeDepth = IN.ase_texcoord5.x;
				float cameraDepthFade148 = (( eyeDepth -_ProjectionParams.y - _CameraDepthFadeOffset ) / _CameraDepthFadeLength);
				float temp_output_20_0_g301 = cameraDepthFade148;
				float temp_output_4_0_g301 = _CameraDepthFadePower;
				float smoothstepResult22_g301 = smoothstep( temp_output_7_0_g301 , temp_output_23_0_g301 , pow( temp_output_20_0_g301 , temp_output_4_0_g301 ));
				float Camera_Depth_Fade151 = smoothstepResult22_g301;
				float Alpha51 = ( saturate( ( ( ( ( pow( Coloured_Base_Alpha47 , _BaseAlphaPower ) * _BaseAlpha ) + ( Additive_Noise155 * Coloured_Base_Alpha47 ) ) - ( _AlphaErosion + Particle_Alpha_Erosion_over_Lifetime135 ) ) - Subtractive_Noise193 ) ) * Depth_Fade143 * Camera_Depth_Fade151 );
				

				float Alpha = Alpha51;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			

			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_VERSION 19701
			#define ASE_SRP_VERSION 140011
			#define REQUIRE_DEPTH_TEXTURE 1


			

			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			
            #if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#endif
		

			
			#if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#endif
		

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			
			#if ASE_SRP_VERSION >=140010
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#endif
		

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "../../VFXToolkit/Shaders/_Includes/Noise.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _DISTORTIONNOISEENABLED_ON
			#pragma shader_feature_local _ADDITIVENOISEENABLED_ON
			#pragma shader_feature_local _SUBTRACTIVENOISEENABLED_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DistortionNoiseOffset;
			float4 _DistortionNoiseAnimation;
			float4 _NormalMap_ST;
			float4 _AdditiveNoiseOffset;
			float4 _AdditiveNoiseAnimation;
			float4 _Colour;
			float4 _SubtractiveNoiseAnimation;
			float4 _SubtractiveNoiseOffset;
			float _DistortionNoiseScale;
			float _AlphaErosion;
			float _ParticleAlphaErosionoverLifetime;
			float _SubtractiveNoiseScale;
			float _SubtractiveNoisePower;
			float _SubtractiveNoise;
			float _DepthFade;
			float _DepthFadePower;
			float _CameraDepthFadeLength;
			float _BaseAlpha;
			float _BaseAlphaPower;
			float _AdditiveNoiseNormalfromHeight;
			float _AdditionalLightsTranslucency;
			float _CameraDepthFadeOffset;
			float _NormalMapScale;
			float _MainLight;
			float _AdditiveNoisetoRGB;
			float _AdditiveNoise;
			float _AdditiveNoisePower;
			float _AdditiveNoiseScale;
			float _DistortionNoise;
			float _DistortionNoiseOctaves;
			float _ParticleRandomization;
			float _AdditionalLights;
			float _CameraDepthFadePower;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _BaseMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			int _ObjectId;
			int _PassValue;

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.positionOS).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.positionOS.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.x = eyeDepth;
				
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord1 = v.positionOS;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = v.normalOS;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );

				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float2 texCoord244 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float localSimplexNoise_float2_g297 = ( 0.0 );
				float Particle_Stable_Random157 = ( ( IN.ase_texcoord.w - 0.5 ) * 100.0 * _ParticleRandomization );
				float4 temp_output_10_0_g295 = ( float4( ( IN.ase_texcoord1.xyz * _DistortionNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _DistortionNoiseOffset + Particle_Stable_Random157 ) + ( _DistortionNoiseAnimation * _TimeParameters.x ) ) );
				float3 position2_g297 = (temp_output_10_0_g295).xyz;
				float angle2_g297 = (temp_output_10_0_g295).w;
				float octaves2_g297 = _DistortionNoiseOctaves;
				float noise2_g297 = 0.0;
				float3 gradient2_g297 = float3( 0,0,0 );
				SimplexNoise_float( position2_g297 , angle2_g297 , octaves2_g297 , noise2_g297 , gradient2_g297 );
				#ifdef _DISTORTIONNOISEENABLED_ON
				float3 staticSwitch233 = ( gradient2_g297 * _DistortionNoise );
				#else
				float3 staticSwitch233 = float3( 0,0,0 );
				#endif
				float3 Distortion_Noise234 = staticSwitch233;
				float4 tex2DNode10 = tex2D( _BaseMap, ( float3( texCoord244 ,  0.0 ) + Distortion_Noise234 ).xy );
				float4 temp_output_10_0_g288 = ( float4( ( IN.ase_texcoord1.xyz * _AdditiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _AdditiveNoiseOffset + Particle_Stable_Random157 ) + ( _AdditiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_154_0 = (temp_output_10_0_g288).xyz;
				float simpleNoise175 = SimpleNoise( temp_output_154_0.xy );
				#ifdef _ADDITIVENOISEENABLED_ON
				float staticSwitch176 = ( pow( simpleNoise175 , _AdditiveNoisePower ) * _AdditiveNoise );
				#else
				float staticSwitch176 = 0.0;
				#endif
				float Additive_Noise155 = staticSwitch176;
				float4 temp_output_40_0 = ( ( tex2DNode10 + ( Additive_Noise155 * _AdditiveNoisetoRGB * float4(1,1,1,0) ) ) * IN.ase_color * _Colour );
				float Coloured_Base_Alpha47 = (temp_output_40_0).a;
				float Particle_Alpha_Erosion_over_Lifetime135 = ( IN.ase_texcoord.z * _ParticleAlphaErosionoverLifetime );
				float4 temp_output_10_0_g298 = ( float4( ( IN.ase_texcoord1.xyz * _SubtractiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _SubtractiveNoiseOffset + Particle_Stable_Random157 ) + ( _SubtractiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_187_0 = (temp_output_10_0_g298).xyz;
				float simpleNoise196 = SimpleNoise( temp_output_187_0.xy );
				#ifdef _SUBTRACTIVENOISEENABLED_ON
				float staticSwitch192 = ( pow( simpleNoise196 , _SubtractiveNoisePower ) * _SubtractiveNoise );
				#else
				float staticSwitch192 = 0.0;
				#endif
				float Subtractive_Noise193 = staticSwitch192;
				float temp_output_7_0_g300 = 0.0;
				float temp_output_23_0_g300 = 1.0;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth14 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthFade ) ) );
				float temp_output_20_0_g300 = distanceDepth14;
				float temp_output_4_0_g300 = _DepthFadePower;
				float smoothstepResult22_g300 = smoothstep( temp_output_7_0_g300 , temp_output_23_0_g300 , pow( temp_output_20_0_g300 , temp_output_4_0_g300 ));
				float Depth_Fade143 = smoothstepResult22_g300;
				float temp_output_7_0_g301 = 0.0;
				float temp_output_23_0_g301 = 1.0;
				float eyeDepth = IN.ase_texcoord3.x;
				float cameraDepthFade148 = (( eyeDepth -_ProjectionParams.y - _CameraDepthFadeOffset ) / _CameraDepthFadeLength);
				float temp_output_20_0_g301 = cameraDepthFade148;
				float temp_output_4_0_g301 = _CameraDepthFadePower;
				float smoothstepResult22_g301 = smoothstep( temp_output_7_0_g301 , temp_output_23_0_g301 , pow( temp_output_20_0_g301 , temp_output_4_0_g301 ));
				float Camera_Depth_Fade151 = smoothstepResult22_g301;
				float Alpha51 = ( saturate( ( ( ( ( pow( Coloured_Base_Alpha47 , _BaseAlphaPower ) * _BaseAlpha ) + ( Additive_Noise155 * Coloured_Base_Alpha47 ) ) - ( _AlphaErosion + Particle_Alpha_Erosion_over_Lifetime135 ) ) - Subtractive_Noise193 ) ) * Depth_Fade143 * Camera_Depth_Fade151 );
				

				surfaceDescription.Alpha = Alpha51;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			

			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_VERSION 19701
			#define ASE_SRP_VERSION 140011
			#define REQUIRE_DEPTH_TEXTURE 1


			

			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT

			#define SHADERPASS SHADERPASS_DEPTHONLY

			
            #if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#endif
		

			
			#if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#endif
		

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			
			#if ASE_SRP_VERSION >=140010
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#endif
		

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#include "../../VFXToolkit/Shaders/_Includes/Noise.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _DISTORTIONNOISEENABLED_ON
			#pragma shader_feature_local _ADDITIVENOISEENABLED_ON
			#pragma shader_feature_local _SUBTRACTIVENOISEENABLED_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DistortionNoiseOffset;
			float4 _DistortionNoiseAnimation;
			float4 _NormalMap_ST;
			float4 _AdditiveNoiseOffset;
			float4 _AdditiveNoiseAnimation;
			float4 _Colour;
			float4 _SubtractiveNoiseAnimation;
			float4 _SubtractiveNoiseOffset;
			float _DistortionNoiseScale;
			float _AlphaErosion;
			float _ParticleAlphaErosionoverLifetime;
			float _SubtractiveNoiseScale;
			float _SubtractiveNoisePower;
			float _SubtractiveNoise;
			float _DepthFade;
			float _DepthFadePower;
			float _CameraDepthFadeLength;
			float _BaseAlpha;
			float _BaseAlphaPower;
			float _AdditiveNoiseNormalfromHeight;
			float _AdditionalLightsTranslucency;
			float _CameraDepthFadeOffset;
			float _NormalMapScale;
			float _MainLight;
			float _AdditiveNoisetoRGB;
			float _AdditiveNoise;
			float _AdditiveNoisePower;
			float _AdditiveNoiseScale;
			float _DistortionNoise;
			float _DistortionNoiseOctaves;
			float _ParticleRandomization;
			float _AdditionalLights;
			float _CameraDepthFadePower;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _BaseMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			float4 _SelectionID;

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.positionOS).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.positionOS.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.x = eyeDepth;
				
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord1 = v.positionOS;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = v.normalOS;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );
				o.positionCS = TransformWorldToHClip(positionWS);
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float2 texCoord244 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float localSimplexNoise_float2_g297 = ( 0.0 );
				float Particle_Stable_Random157 = ( ( IN.ase_texcoord.w - 0.5 ) * 100.0 * _ParticleRandomization );
				float4 temp_output_10_0_g295 = ( float4( ( IN.ase_texcoord1.xyz * _DistortionNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _DistortionNoiseOffset + Particle_Stable_Random157 ) + ( _DistortionNoiseAnimation * _TimeParameters.x ) ) );
				float3 position2_g297 = (temp_output_10_0_g295).xyz;
				float angle2_g297 = (temp_output_10_0_g295).w;
				float octaves2_g297 = _DistortionNoiseOctaves;
				float noise2_g297 = 0.0;
				float3 gradient2_g297 = float3( 0,0,0 );
				SimplexNoise_float( position2_g297 , angle2_g297 , octaves2_g297 , noise2_g297 , gradient2_g297 );
				#ifdef _DISTORTIONNOISEENABLED_ON
				float3 staticSwitch233 = ( gradient2_g297 * _DistortionNoise );
				#else
				float3 staticSwitch233 = float3( 0,0,0 );
				#endif
				float3 Distortion_Noise234 = staticSwitch233;
				float4 tex2DNode10 = tex2D( _BaseMap, ( float3( texCoord244 ,  0.0 ) + Distortion_Noise234 ).xy );
				float4 temp_output_10_0_g288 = ( float4( ( IN.ase_texcoord1.xyz * _AdditiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _AdditiveNoiseOffset + Particle_Stable_Random157 ) + ( _AdditiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_154_0 = (temp_output_10_0_g288).xyz;
				float simpleNoise175 = SimpleNoise( temp_output_154_0.xy );
				#ifdef _ADDITIVENOISEENABLED_ON
				float staticSwitch176 = ( pow( simpleNoise175 , _AdditiveNoisePower ) * _AdditiveNoise );
				#else
				float staticSwitch176 = 0.0;
				#endif
				float Additive_Noise155 = staticSwitch176;
				float4 temp_output_40_0 = ( ( tex2DNode10 + ( Additive_Noise155 * _AdditiveNoisetoRGB * float4(1,1,1,0) ) ) * IN.ase_color * _Colour );
				float Coloured_Base_Alpha47 = (temp_output_40_0).a;
				float Particle_Alpha_Erosion_over_Lifetime135 = ( IN.ase_texcoord.z * _ParticleAlphaErosionoverLifetime );
				float4 temp_output_10_0_g298 = ( float4( ( IN.ase_texcoord1.xyz * _SubtractiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _SubtractiveNoiseOffset + Particle_Stable_Random157 ) + ( _SubtractiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_187_0 = (temp_output_10_0_g298).xyz;
				float simpleNoise196 = SimpleNoise( temp_output_187_0.xy );
				#ifdef _SUBTRACTIVENOISEENABLED_ON
				float staticSwitch192 = ( pow( simpleNoise196 , _SubtractiveNoisePower ) * _SubtractiveNoise );
				#else
				float staticSwitch192 = 0.0;
				#endif
				float Subtractive_Noise193 = staticSwitch192;
				float temp_output_7_0_g300 = 0.0;
				float temp_output_23_0_g300 = 1.0;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth14 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthFade ) ) );
				float temp_output_20_0_g300 = distanceDepth14;
				float temp_output_4_0_g300 = _DepthFadePower;
				float smoothstepResult22_g300 = smoothstep( temp_output_7_0_g300 , temp_output_23_0_g300 , pow( temp_output_20_0_g300 , temp_output_4_0_g300 ));
				float Depth_Fade143 = smoothstepResult22_g300;
				float temp_output_7_0_g301 = 0.0;
				float temp_output_23_0_g301 = 1.0;
				float eyeDepth = IN.ase_texcoord3.x;
				float cameraDepthFade148 = (( eyeDepth -_ProjectionParams.y - _CameraDepthFadeOffset ) / _CameraDepthFadeLength);
				float temp_output_20_0_g301 = cameraDepthFade148;
				float temp_output_4_0_g301 = _CameraDepthFadePower;
				float smoothstepResult22_g301 = smoothstep( temp_output_7_0_g301 , temp_output_23_0_g301 , pow( temp_output_20_0_g301 , temp_output_4_0_g301 ));
				float Camera_Depth_Fade151 = smoothstepResult22_g301;
				float Alpha51 = ( saturate( ( ( ( ( pow( Coloured_Base_Alpha47 , _BaseAlphaPower ) * _BaseAlpha ) + ( Additive_Noise155 * Coloured_Base_Alpha47 ) ) - ( _AlphaErosion + Particle_Alpha_Erosion_over_Lifetime135 ) ) - Subtractive_Noise193 ) ) * Depth_Fade143 * Camera_Depth_Fade151 );
				

				surfaceDescription.Alpha = Alpha51;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;
				outColor = _SelectionID;

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormalsOnly" }

			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			

        	#pragma multi_compile_instancing
        	#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
        	#define ASE_FOG 1
        	#define _SURFACE_TYPE_TRANSPARENT 1
        	#define ASE_VERSION 19701
        	#define ASE_SRP_VERSION 140011
        	#define REQUIRE_DEPTH_TEXTURE 1


			

        	#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

			

			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define VARYINGS_NEED_NORMAL_WS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			
            #if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#endif
		

			
			#if ASE_SRP_VERSION >=140007
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#endif
		

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			
			#if ASE_SRP_VERSION >=140010
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#endif
		

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

            #if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#include "../../VFXToolkit/Shaders/_Includes/Noise.cginc"
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _DISTORTIONNOISEENABLED_ON
			#pragma shader_feature_local _ADDITIVENOISEENABLED_ON
			#pragma shader_feature_local _SUBTRACTIVENOISEENABLED_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DistortionNoiseOffset;
			float4 _DistortionNoiseAnimation;
			float4 _NormalMap_ST;
			float4 _AdditiveNoiseOffset;
			float4 _AdditiveNoiseAnimation;
			float4 _Colour;
			float4 _SubtractiveNoiseAnimation;
			float4 _SubtractiveNoiseOffset;
			float _DistortionNoiseScale;
			float _AlphaErosion;
			float _ParticleAlphaErosionoverLifetime;
			float _SubtractiveNoiseScale;
			float _SubtractiveNoisePower;
			float _SubtractiveNoise;
			float _DepthFade;
			float _DepthFadePower;
			float _CameraDepthFadeLength;
			float _BaseAlpha;
			float _BaseAlphaPower;
			float _AdditiveNoiseNormalfromHeight;
			float _AdditionalLightsTranslucency;
			float _CameraDepthFadeOffset;
			float _NormalMapScale;
			float _MainLight;
			float _AdditiveNoisetoRGB;
			float _AdditiveNoise;
			float _AdditiveNoisePower;
			float _AdditiveNoiseScale;
			float _DistortionNoise;
			float _DistortionNoiseOctaves;
			float _ParticleRandomization;
			float _AdditionalLights;
			float _CameraDepthFadePower;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _BaseMap;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.positionOS.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.x = eyeDepth;
				
				o.ase_texcoord2 = v.ase_texcoord;
				o.ase_texcoord3 = v.positionOS;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = v.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				o.normalWS = TransformObjectToWorldNormal( v.normalOS );
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			void frag( VertexOutput IN
				, out half4 outNormalWS : SV_Target0
			#ifdef _WRITE_RENDERING_LAYERS
				, out float4 outRenderingLayers : SV_Target1
			#endif
				 )
			{
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 texCoord244 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float localSimplexNoise_float2_g297 = ( 0.0 );
				float Particle_Stable_Random157 = ( ( IN.ase_texcoord2.w - 0.5 ) * 100.0 * _ParticleRandomization );
				float4 temp_output_10_0_g295 = ( float4( ( IN.ase_texcoord3.xyz * _DistortionNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _DistortionNoiseOffset + Particle_Stable_Random157 ) + ( _DistortionNoiseAnimation * _TimeParameters.x ) ) );
				float3 position2_g297 = (temp_output_10_0_g295).xyz;
				float angle2_g297 = (temp_output_10_0_g295).w;
				float octaves2_g297 = _DistortionNoiseOctaves;
				float noise2_g297 = 0.0;
				float3 gradient2_g297 = float3( 0,0,0 );
				SimplexNoise_float( position2_g297 , angle2_g297 , octaves2_g297 , noise2_g297 , gradient2_g297 );
				#ifdef _DISTORTIONNOISEENABLED_ON
				float3 staticSwitch233 = ( gradient2_g297 * _DistortionNoise );
				#else
				float3 staticSwitch233 = float3( 0,0,0 );
				#endif
				float3 Distortion_Noise234 = staticSwitch233;
				float4 tex2DNode10 = tex2D( _BaseMap, ( float3( texCoord244 ,  0.0 ) + Distortion_Noise234 ).xy );
				float4 temp_output_10_0_g288 = ( float4( ( IN.ase_texcoord3.xyz * _AdditiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _AdditiveNoiseOffset + Particle_Stable_Random157 ) + ( _AdditiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_154_0 = (temp_output_10_0_g288).xyz;
				float simpleNoise175 = SimpleNoise( temp_output_154_0.xy );
				#ifdef _ADDITIVENOISEENABLED_ON
				float staticSwitch176 = ( pow( simpleNoise175 , _AdditiveNoisePower ) * _AdditiveNoise );
				#else
				float staticSwitch176 = 0.0;
				#endif
				float Additive_Noise155 = staticSwitch176;
				float4 temp_output_40_0 = ( ( tex2DNode10 + ( Additive_Noise155 * _AdditiveNoisetoRGB * float4(1,1,1,0) ) ) * IN.ase_color * _Colour );
				float Coloured_Base_Alpha47 = (temp_output_40_0).a;
				float Particle_Alpha_Erosion_over_Lifetime135 = ( IN.ase_texcoord2.z * _ParticleAlphaErosionoverLifetime );
				float4 temp_output_10_0_g298 = ( float4( ( IN.ase_texcoord3.xyz * _SubtractiveNoiseScale * float3( 1,1,1 ) ) , 0.0 ) - ( ( _SubtractiveNoiseOffset + Particle_Stable_Random157 ) + ( _SubtractiveNoiseAnimation * _TimeParameters.x ) ) );
				float3 temp_output_187_0 = (temp_output_10_0_g298).xyz;
				float simpleNoise196 = SimpleNoise( temp_output_187_0.xy );
				#ifdef _SUBTRACTIVENOISEENABLED_ON
				float staticSwitch192 = ( pow( simpleNoise196 , _SubtractiveNoisePower ) * _SubtractiveNoise );
				#else
				float staticSwitch192 = 0.0;
				#endif
				float Subtractive_Noise193 = staticSwitch192;
				float temp_output_7_0_g300 = 0.0;
				float temp_output_23_0_g300 = 1.0;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth14 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth14 = saturate( abs( ( screenDepth14 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _DepthFade ) ) );
				float temp_output_20_0_g300 = distanceDepth14;
				float temp_output_4_0_g300 = _DepthFadePower;
				float smoothstepResult22_g300 = smoothstep( temp_output_7_0_g300 , temp_output_23_0_g300 , pow( temp_output_20_0_g300 , temp_output_4_0_g300 ));
				float Depth_Fade143 = smoothstepResult22_g300;
				float temp_output_7_0_g301 = 0.0;
				float temp_output_23_0_g301 = 1.0;
				float eyeDepth = IN.ase_texcoord4.x;
				float cameraDepthFade148 = (( eyeDepth -_ProjectionParams.y - _CameraDepthFadeOffset ) / _CameraDepthFadeLength);
				float temp_output_20_0_g301 = cameraDepthFade148;
				float temp_output_4_0_g301 = _CameraDepthFadePower;
				float smoothstepResult22_g301 = smoothstep( temp_output_7_0_g301 , temp_output_23_0_g301 , pow( temp_output_20_0_g301 , temp_output_4_0_g301 ));
				float Camera_Depth_Fade151 = smoothstepResult22_g301;
				float Alpha51 = ( saturate( ( ( ( ( pow( Coloured_Base_Alpha47 , _BaseAlphaPower ) * _BaseAlpha ) + ( Additive_Noise155 * Coloured_Base_Alpha47 ) ) - ( _AlphaErosion + Particle_Alpha_Erosion_over_Lifetime135 ) ) - Subtractive_Noise193 ) ) * Depth_Fade143 * Camera_Depth_Fade151 );
				

				float Alpha = Alpha51;
				float AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float3 normalWS = normalize(IN.normalWS);
					float2 octNormalWS = PackNormalOctQuadEncode(normalWS);           // values between [-1, +1], must use fp32 on some platforms
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);   // values between [ 0,  1]
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);      // values between [ 0,  1]
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					float3 normalWS = IN.normalWS;
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4(EncodeMeshRenderingLayer(renderingLayers), 0, 0, 0);
				#endif
			}

			ENDHLSL
		}

	
	}
	
	CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19701
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-3328,-640;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;163;-2944,-384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-2944,-256;Inherit;False;Property;_ParticleRandomization;Particle Randomization;14;0;Create;True;0;0;0;False;2;Header(Particle Settings);Space(5);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-2560,-384;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;100;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;157;-2304,-384;Inherit;False;Particle Stable Random;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-4224,3408;Inherit;False;157;Particle Stable Random;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;162;-4224,3216;Inherit;False;Property;_AdditiveNoiseOffset;Additive Noise Offset;24;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;236;-8192,-176;Inherit;False;157;Particle Stable Random;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;237;-8192,-368;Inherit;False;Property;_DistortionNoiseOffset;Distortion Noise Offset;40;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;159;-4224,2816;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;166;-3840,3216;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-4224,2960;Inherit;False;Property;_AdditiveNoiseScale;Additive Noise Scale;22;0;Create;True;0;0;0;False;0;False;40;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;161;-4224,3040;Inherit;False;Property;_AdditiveNoiseAnimation;Additive Noise Animation;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;238;-8192,-768;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;239;-7808,-368;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;240;-8192,-624;Inherit;False;Property;_DistortionNoiseScale;Distortion Noise Scale;38;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;241;-8192,-544;Inherit;False;Property;_DistortionNoiseAnimation;Distortion Noise Animation;39;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;154;-3584,2816;Inherit;False;Scale Tiling Offset Animation;-1;;288;650501f4d90f3194eb72a847e06cc2e3;1,21,0;6;4;FLOAT3;0,0,0;False;7;FLOAT;1;False;8;FLOAT3;1,1,1;False;9;FLOAT4;0,0,0,0;False;19;INT;0;False;12;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;242;-7552,-768;Inherit;False;Scale Tiling Offset Animation;-1;;295;650501f4d90f3194eb72a847e06cc2e3;1,21,0;6;4;FLOAT3;0,0,0;False;7;FLOAT;1;False;8;FLOAT3;1,1,1;False;9;FLOAT4;0,0,0,0;False;19;INT;0;False;12;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;243;-7552,-592;Inherit;False;Property;_DistortionNoiseOctaves;Distortion Noise Octaves;41;1;[IntRange];Create;True;0;0;0;False;0;False;1;0;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;175;-3200,2560;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-3200,2944;Inherit;False;Property;_AdditiveNoisePower;Additive Noise Power;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;235;-7168,-768;Inherit;False;Simplex Noise;-1;;297;c68ae2e20c00ec54aaecd9d04797372e;0;3;4;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;FLOAT;1;False;2;FLOAT;0;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;231;-6784,-640;Inherit;False;Property;_DistortionNoise;Distortion Noise;36;0;Create;True;0;0;0;False;2;Header(Distortion Noise);Space(5);False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;170;-2816,2816;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-2816,2944;Inherit;False;Property;_AdditiveNoise;Additive Noise;20;0;Create;True;0;0;0;False;2;Header(Additive Noise);Space(5);False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-6400,-768;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-2432,2816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;233;-6144,-768;Inherit;False;Property;_DistortionNoiseEnabled;Distortion Noise Enabled;37;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;176;-2176,2816;Inherit;False;Property;_AdditiveNoiseEnabled;Additive Noise Enabled;21;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-5760,-768;Inherit;False;Distortion Noise;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;-1792,2816;Inherit;False;Additive Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-5504,-1024;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;246;-5504,-896;Inherit;False;234;Distortion Noise;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-4992,-816;Inherit;False;155;Additive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;220;-4992,-656;Inherit;False;Constant;_Vector0;Vector 0;35;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;223;-4992,-736;Inherit;False;Property;_AdditiveNoisetoRGB;Additive Noise to RGB;27;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;245;-5248,-1024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;10;-4992,-1024;Inherit;True;Property;_BaseMap;Base Map;3;0;Create;True;0;0;0;False;2;Header(Texture);Space(5);False;-1;e727c3978c253c54ea6bc105a8da932e;e727c3978c253c54ea6bc105a8da932e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-4480,-816;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-4224,4176;Inherit;False;157;Particle Stable Random;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;181;-4224,3984;Inherit;False;Property;_SubtractiveNoiseOffset;Subtractive Noise Offset;33;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;43;-4224,-768;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;122;-4224,-592;Inherit;False;Property;_Colour;Colour;0;1;[HDR];Create;True;0;0;0;False;2;Header(Colour);Space(5);False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;217;-4224,-1024;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;183;-4224,3584;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-3840,3984;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-4224,3728;Inherit;False;Property;_SubtractiveNoiseScale;Subtractive Noise Scale;31;0;Create;True;0;0;0;False;0;False;40;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;184;-4224,3808;Inherit;False;Property;_SubtractiveNoiseAnimation;Subtractive Noise Animation;32;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3584,-1024;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;187;-3584,3584;Inherit;False;Scale Tiling Offset Animation;-1;;298;650501f4d90f3194eb72a847e06cc2e3;1,21,0;6;4;FLOAT3;0,0,0;False;7;FLOAT;1;False;8;FLOAT3;1,1,1;False;9;FLOAT4;0,0,0,0;False;19;INT;0;False;12;FLOAT4;0,0,0,0;False;2;FLOAT3;0;FLOAT;15
Node;AmplifyShaderEditor.ComponentMaskNode;46;-3328,-896;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-2944,-512;Inherit;False;Property;_ParticleAlphaErosionoverLifetime;Particle Alpha Erosion over Lifetime;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-3200,3712;Inherit;False;Property;_SubtractiveNoisePower;Subtractive Noise Power;35;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-3072,-896;Inherit;False;Coloured Base Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;196;-3200,3328;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-2560,-640;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;189;-2816,3584;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;190;-2816,3712;Inherit;False;Property;_SubtractiveNoise;Subtractive Noise;29;0;Create;True;0;0;0;False;2;Header(Subtractive Noise);Space(5);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-4352,384;Inherit;False;47;Coloured Base Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-4352,512;Inherit;False;Property;_BaseAlphaPower;Base Alpha Power;5;0;Create;True;0;0;0;False;0;False;1;1;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-2304,-640;Inherit;False;Particle Alpha Erosion over Lifetime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;-2432,3584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-4352,720;Inherit;False;47;Coloured Base Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;-4352,640;Inherit;False;155;Additive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;142;-3968,384;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-3968,512;Inherit;False;Property;_BaseAlpha;Base Alpha;4;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-2944,80;Inherit;False;Property;_CameraDepthFadeOffset;Camera Depth Fade Offset;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-2944,0;Inherit;False;Property;_CameraDepthFadeLength;Camera Depth Fade Length;11;0;Create;True;0;0;0;False;2;Header(Camera Depth Fade);Space(5);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-4224,0;Inherit;False;Property;_DepthFade;Depth Fade;9;0;Create;True;0;0;0;False;2;Header(Depth Fade);Space(5);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;192;-2176,3584;Inherit;False;Property;_SubtractiveNoiseEnabled;Subtractive Noise Enabled;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-3584,640;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-3328,592;Inherit;False;135;Particle Alpha Erosion over Lifetime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-3328,512;Inherit;False;Property;_AlphaErosion;Alpha Erosion;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-3584,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-3968,128;Inherit;False;Property;_DepthFadePower;Depth Fade Power;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;14;-3968,0;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;148;-2560,0;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-2560,128;Inherit;False;Property;_CameraDepthFadePower;Camera Depth Fade Power;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;193;-1792,3584;Inherit;False;Subtractive Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;212;-3328,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-2944,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;120;-3584,0;Inherit;False;Power Smoothstep;-1;;300;eaa8bfb6a4986cb418a1675cea297eed;1,24,0;4;20;FLOAT;1;False;4;FLOAT;1;False;7;FLOAT;0;False;23;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;150;-2176,0;Inherit;False;Power Smoothstep;-1;;301;eaa8bfb6a4986cb418a1675cea297eed;1,24,0;4;20;FLOAT;1;False;4;FLOAT;1;False;7;FLOAT;0;False;23;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;129;-2688,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-2688,512;Inherit;False;193;Subtractive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-3200,0;Inherit;False;Depth Fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-1792,0;Inherit;False;Camera Depth Fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;172;-2432,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-2304,512;Inherit;False;143;Depth Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-2304,592;Inherit;False;151;Camera Depth Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;-2176,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1920,384;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-1664,384;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-384,128;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-384,0;Inherit;False;86;Colour;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-4224,-384;Inherit;False;Property;_NormalMapScale;Normal Map Scale;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;123;-3968,-384;Inherit;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;0;False;0;False;-1;e727c3978c253c54ea6bc105a8da932e;e727c3978c253c54ea6bc105a8da932e;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ComponentMaskNode;45;-3328,-1024;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-384,256;Inherit;False;51;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;199;-3856,-1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;-3328,-1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-3072,-1280;Inherit;False;Base R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;207;-3584,-256;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-3328,-384;Inherit;False;Normal Map;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;208;-3328,-256;Inherit;False;Negative Normal Map;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-3072,-1024;Inherit;False;Coloured Base RGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-3840,-1152;Inherit;False;155;Additive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-2048,1280;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;98;-2560,1280;Inherit;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;99;-2560,1408;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-2304,1408;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-2560,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2944,1536;Inherit;False;115;Base R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;109;-1792,1152;Inherit;False;Property;_AdditionalLightsTranslucencyEnabled;Additional Lights Translucency Enabled;19;0;Create;True;0;0;0;False;1;Space(5);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-3200,2176;Inherit;False;Colour;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;119;-3584,2176;Inherit;False;Property;_LightingEnabled;Lighting Enabled;15;0;Create;True;0;0;0;False;2;Header(Lighting);Space(5);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;88;-2944,1280;Inherit;False;SRP Additional Light;-1;;302;6c86746ad131a0a408ca599df5f40861;3,6,1,9,0,23,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2944,1616;Inherit;False;Property;_AdditionalLightsTranslucency;Additional Lights Translucency;18;0;Create;True;0;0;0;False;0;False;1;0;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-4224,1920;Inherit;False;Property;_MainLight;Main Light;16;0;Create;True;0;0;0;False;1;Space(5);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-3840,1792;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-3840,1920;Inherit;False;113;Additional Lights;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-3456,1792;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-3328,1792;Inherit;False;Lighting;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;102;-4224,1792;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;111;-1792,1280;Inherit;False;Property;_AdditionalLights;Additional Lights;17;0;Create;True;0;0;0;False;1;Space(5);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;195;-3200,3584;Inherit;False;Simplex Noise;-1;;304;c68ae2e20c00ec54aaecd9d04797372e;0;3;4;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;FLOAT;1;False;2;FLOAT;0;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;194;-3584,3760;Inherit;False;Property;_SubtractiveNoiseOctaves;Subtractive Noise Octaves;34;1;[IntRange];Create;True;0;0;0;False;0;False;1;0;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;87;-2944,1152;Inherit;False;SRP Additional Light;-1;;305;6c86746ad131a0a408ca599df5f40861;3,6,1,9,0,23,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-4480,1408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;90;-4736,1408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;103;-4224,1280;Inherit;False;Normal From Height;-1;;307;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;200;-3712,1152;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;201;-3712,1280;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;-3712,1408;Inherit;False;208;Negative Normal Map;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-4992,1232;Inherit;False;Property;_AdditiveNoiseNormalfromHeight;Additive Noise Normal from Height;28;0;Create;True;0;0;0;False;1;Space(5);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-4992,1408;Inherit;False;155;Additive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-4224,2176;Inherit;False;48;Coloured Base RGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-4224,2304;Inherit;False;96;Lighting;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-3840,2304;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1280,1152;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-1024,1152;Inherit;False;Additional Lights;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-4992,1152;Inherit;False;155;Additive Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;203;-3328,1024;Inherit;False;Property;_Keyword0;Keyword 0;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;176;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;104;-4224,1152;Inherit;False;Normal From Height;-1;;308;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;209;-4224,1408;Inherit;False;208;Negative Normal Map;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;206;-4224,1024;Inherit;False;125;Normal Map;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;153;-3200,2816;Inherit;False;Simplex Noise;-1;;309;c68ae2e20c00ec54aaecd9d04797372e;0;3;4;FLOAT3;0,0,0;False;6;FLOAT;0;False;7;FLOAT;1;False;2;FLOAT;0;FLOAT3;3
Node;AmplifyShaderEditor.RangedFloatNode;156;-3584,2992;Inherit;False;Property;_AdditiveNoiseOctaves;Additive Noise Octaves;25;1;[IntRange];Create;True;0;0;0;False;0;False;1;0;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-7168,-640;Inherit;False;Property;_DistortionNoisePower;Distortion Noise Power;42;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;205;-3328,1408;Inherit;False;Property;_Keyword1;Keyword 0;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;176;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;76;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;77;0,0;Float;False;True;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;Mirza/Smoke;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForwardOnly;False;False;0;;0;0;Standard;23;Surface;1;638687650521782574;  Blend;0;0;Two Sided;0;638687676030191110;Forward Only;0;0;Alpha Clipping;0;638687650528450418;  Use Shadow Threshold;0;0;Cast Shadows;0;638687686610047826;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;Meta Pass;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,True,_Tessellation;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Vertex Position,InvertActionOnDeselection;1;0;0;10;False;True;False;True;False;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;78;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;79;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;80;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;81;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;82;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;83;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ScenePickingPass;0;7;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;84;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormals;0;8;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;85;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormalsOnly;0;9;DepthNormalsOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;True;9;d3d11;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;;0;0;Standard;0;False;0
WireConnection;163;0;132;4
WireConnection;165;0;163;0
WireConnection;165;2;164;0
WireConnection;157;0;165;0
WireConnection;166;0;162;0
WireConnection;166;1;167;0
WireConnection;239;0;237;0
WireConnection;239;1;236;0
WireConnection;154;4;159;0
WireConnection;154;7;160;0
WireConnection;154;9;161;0
WireConnection;154;12;166;0
WireConnection;242;4;238;0
WireConnection;242;7;240;0
WireConnection;242;9;241;0
WireConnection;242;12;239;0
WireConnection;175;0;154;0
WireConnection;235;4;242;0
WireConnection;235;6;242;15
WireConnection;235;7;243;0
WireConnection;170;0;175;0
WireConnection;170;1;171;0
WireConnection;232;0;235;3
WireConnection;232;1;231;0
WireConnection;168;0;170;0
WireConnection;168;1;169;0
WireConnection;233;0;232;0
WireConnection;176;0;168;0
WireConnection;234;0;233;0
WireConnection;155;0;176;0
WireConnection;245;0;244;0
WireConnection;245;1;246;0
WireConnection;10;1;245;0
WireConnection;219;0;218;0
WireConnection;219;1;223;0
WireConnection;219;2;220;0
WireConnection;217;0;10;0
WireConnection;217;1;219;0
WireConnection;185;0;181;0
WireConnection;185;1;182;0
WireConnection;40;0;217;0
WireConnection;40;1;43;0
WireConnection;40;2;122;0
WireConnection;187;4;183;0
WireConnection;187;7;186;0
WireConnection;187;9;184;0
WireConnection;187;12;185;0
WireConnection;46;0;40;0
WireConnection;47;0;46;0
WireConnection;196;0;187;0
WireConnection;134;0;132;3
WireConnection;134;1;133;0
WireConnection;189;0;196;0
WireConnection;189;1;188;0
WireConnection;135;0;134;0
WireConnection;191;0;189;0
WireConnection;191;1;190;0
WireConnection;142;0;50;0
WireConnection;142;1;141;0
WireConnection;192;0;191;0
WireConnection;213;0;180;0
WireConnection;213;1;214;0
WireConnection;226;0;142;0
WireConnection;226;1;227;0
WireConnection;14;0;16;0
WireConnection;148;0;147;0
WireConnection;148;1;146;0
WireConnection;193;0;192;0
WireConnection;212;0;226;0
WireConnection;212;1;213;0
WireConnection;137;0;130;0
WireConnection;137;1;138;0
WireConnection;120;20;14;0
WireConnection;120;4;121;0
WireConnection;150;20;148;0
WireConnection;150;4;149;0
WireConnection;129;0;212;0
WireConnection;129;1;137;0
WireConnection;143;0;120;0
WireConnection;151;0;150;0
WireConnection;172;0;129;0
WireConnection;172;1;173;0
WireConnection;131;0;172;0
WireConnection;144;0;131;0
WireConnection;144;1;145;0
WireConnection;144;2;152;0
WireConnection;51;0;144;0
WireConnection;123;5;124;0
WireConnection;45;0;40;0
WireConnection;199;0;10;1
WireConnection;197;0;199;0
WireConnection;197;1;198;0
WireConnection;115;0;197;0
WireConnection;207;0;123;0
WireConnection;125;0;123;0
WireConnection;208;0;207;0
WireConnection;48;0;45;0
WireConnection;97;0;87;0
WireConnection;97;1;100;0
WireConnection;98;0;88;0
WireConnection;99;0;88;0
WireConnection;100;0;98;0
WireConnection;100;1;99;0
WireConnection;100;2;101;0
WireConnection;101;0;107;0
WireConnection;101;1;108;0
WireConnection;109;1;87;0
WireConnection;109;0;97;0
WireConnection;86;0;119;0
WireConnection;119;1;116;0
WireConnection;119;0;117;0
WireConnection;88;2;205;0
WireConnection;93;0;102;1
WireConnection;93;1;102;2
WireConnection;93;2;92;0
WireConnection;95;0;93;0
WireConnection;95;1;94;0
WireConnection;96;0;95;0
WireConnection;195;4;187;0
WireConnection;195;6;187;15
WireConnection;195;7;194;0
WireConnection;87;2;203;0
WireConnection;106;0;90;0
WireConnection;90;0;89;0
WireConnection;103;20;106;0
WireConnection;103;110;105;0
WireConnection;200;0;104;40
WireConnection;200;1;206;0
WireConnection;201;0;103;40
WireConnection;201;1;209;0
WireConnection;117;0;116;0
WireConnection;117;1;118;0
WireConnection;112;0;109;0
WireConnection;112;1;111;0
WireConnection;113;0;112;0
WireConnection;203;1;206;0
WireConnection;203;0;200;0
WireConnection;104;20;110;0
WireConnection;104;110;105;0
WireConnection;153;4;154;0
WireConnection;153;6;154;15
WireConnection;153;7;156;0
WireConnection;205;1;210;0
WireConnection;205;0;201;0
WireConnection;77;2;49;0
WireConnection;77;3;52;0
ASEEND*/
//CHKSM=DBFECAAE38EEA88D71CE03306ED8DE568244A12F