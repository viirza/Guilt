using System;
using System.Threading.Tasks;
using GameCreator.Runtime.Common;
using GameCreator.Runtime.VisualScripting;
using UnityEngine;

[Version(1, 0, 2)]

[Title("Line Renderer Basic")]
[Description("Draws a line renderer between two Vector3 variables.")]

[Category("Renderer/Line Renderer Basic")]

[Parameter(
    "lineEmitter",
    "The gameobject that will contain the line. This object must have a LineRenderer component but does not need to be either of the transforms of the line (see below)."
)]

[Parameter(
    "lineRendererMaterial",
    "The material to use on the line renderer"
)]

[Parameter(
    "pointOne and pointTwo",
    "The start and End transforms of the Line (Game Object or Variable)"
)]

[Parameter(
    "Line Width",
    "Width at the start and end of the line"
)]

[Parameter(
    "Color",
    "Color at the start and end of the line. Leave white if using a colorful material or use alpha and HDR options to blend and glow."
)]


[Keywords("Line Renderer", "Laser", "Line")]
[Image(typeof(IconCubeOutline), ColorTheme.Type.Green, typeof(OverlayArrowLeft))]

[Serializable]
public class InstructionLineRendererBasic : Instruction
{

    // Apply these values in the editor

    public GameObject lineEmitter;
    public Material lineRendererMaterial;
    //    [SerializeField] private PropertySetVector3 m_pointOne;
    [SerializeField] private PropertyGetPosition m_pointOne;
    [SerializeField] private PropertyGetPosition m_pointTwo;
    [SerializeField] private LineRenderer lineRenderer;

    // Line Width

    public float startWidth = 0.2f;
    public float endWidth = 0.2f;

    // Start and End Color HDR

    [ColorUsageAttribute(true, true)]
    public Color startColor;
    [ColorUsageAttribute(true, true)]
    public Color endColor;
    protected override Task Run(Args args)
    {

        Vector3 pointOne = this.m_pointOne.Get(args);
        Vector3 pointTwo = this.m_pointTwo.Get(args);

        LineRenderer lineRenderer = lineEmitter.GetComponent<LineRenderer>();

        lineRenderer.material = lineRendererMaterial;
        // set the color of the line
        lineRenderer.startColor = startColor;
        lineRenderer.endColor = endColor;

        // set width of the renderer
        lineRenderer.startWidth = startWidth;
        lineRenderer.endWidth = endWidth;

        // set the position
        lineRenderer.SetPosition(0, pointOne);
        lineRenderer.SetPosition(1, pointTwo);

        return DefaultResult;
    }
}
