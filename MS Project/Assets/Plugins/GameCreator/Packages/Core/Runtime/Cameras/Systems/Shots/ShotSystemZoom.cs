﻿using System;
using UnityEngine;
using GameCreator.Runtime.Common;

namespace GameCreator.Runtime.Cameras
{
    [Serializable]
    public class ShotSystemZoom : TShotSystem
    {
        public static readonly int ID = nameof(ShotSystemZoom).GetHashCode();
        
        // EXPOSED MEMBERS: -----------------------------------------------------------------------
        
        [SerializeField, Range(0f, 1f)] private float m_TargetZoom = 1f;

        [SerializeField] private float m_MinDistance = 0.5f;
        [SerializeField] private float m_SmoothTime = 0.1f;

        [SerializeField] private InputPropertyValueVector2 m_InputZoom = InputValueVector2Scroll.Create();
        [SerializeField] private PropertyGetDecimal m_Sensitivity = GetDecimalDecimal.Create(0.01f);
        
        // MEMBERS: -------------------------------------------------------------------------------
        
        [NonSerialized] private float m_Velocity;

        // PROPERTIES: ----------------------------------------------------------------------------

        public override int Id => ID;

        /// <summary>
        /// The approximate time it will take to go from the current zoom to its target
        /// </summary>
        public float SmoothTime
        {
            get => this.m_SmoothTime;
            set => this.m_SmoothTime = value;
        }

        /// <summary>
        /// A value between 0 and 1 representing the percentage of the current zoom
        /// </summary>
        public float Level { get; set; }

        /// <summary>
        /// Minimum distance to the target
        /// </summary>
        public float MinDistance
        {
            get => this.m_MinDistance;
            set => this.m_MinDistance = value;
        }

        // IMPLEMENTS: ----------------------------------------------------------------------------

        public override void OnAwake(TShotType shotType)
        {
            base.OnAwake(shotType);
            this.m_InputZoom.OnStartup();
            
            this.Level = 1f;
        }

        public override void OnDestroy(TShotType shotType)
        {
            base.OnDestroy(shotType);
            this.m_InputZoom.OnDispose();
        }

        public override void OnUpdate(TShotType shotType)
        {
            base.OnUpdate(shotType);
            this.m_InputZoom.OnUpdate();
            
            if (shotType.IsActive)
            {
                float sensitivity = (float) this.m_Sensitivity.Get(shotType.Args);
                float delta = -this.m_InputZoom.Read().y * sensitivity;
                
                this.m_TargetZoom = Mathf.Clamp01(this.m_TargetZoom + delta);
            }

            float deltaTime = shotType.ShotCamera.TimeMode.DeltaTime;
            
            this.Level = deltaTime > float.Epsilon
                ? Mathf.SmoothDamp(
                    this.Level,
                    this.m_TargetZoom,
                    ref this.m_Velocity,
                    this.m_SmoothTime,
                    Mathf.Infinity,
                    deltaTime
                )
                : this.Level;
        }
    }
}