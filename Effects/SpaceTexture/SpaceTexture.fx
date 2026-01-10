
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
// displacer ; 

float reinterval(float inVal, float oldMin, float oldMax, float newMin, float newMax) {
	inVal -= oldMin;
	inVal *= (newMax - newMin);
	inVal /= (oldMax - oldMin);
	inVal += newMin;
	return inVal;
}


// Global variables
sampler2D img;
float fDisp;
float fSpeed;
 

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    float2 uv = In.Texture;	
   
        float4 color0;
        float2 offset = tex2D(img, uv).rr;
        offset.x *= sin(fSpeed*0.06+uv.x);
        offset.y *= cos(fSpeed*0.06+uv.x);
        offset*= fDisp;

        color0 = tex2D(img, uv+offset);
        
        color0.rgb += float3(0.01, 0.02, 0.05) * tex2D(img, uv).r * 4.0f; 

       float t = reinterval(sin(fSpeed*0.001), -1.0, 1.0, 0.2, 0.8);
       float4 color = lerp(color0, color0, t);

        Out.Color   = color ; 
 

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}