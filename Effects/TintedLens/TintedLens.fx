// Global variables
sampler2D tex0;
sampler2D bg : register(s1);
const float lensBase, lensCoeff;
const float4 tintColor;
const float tintPow, tintOrigPow;
const float fPixelWidth, fPixelHeight;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
    float height = lensBase + tex2D(tex0, In).r * lensCoeff;
    In += (height - 1.0f) / 2.0f;
    
    float4 col = tex2D(bg, In / height);
    col.rgb = col.rgb*tintOrigPow + col.rgb*tintColor*tintPow;   
    return col;
}

// Effect technique
technique tech_main
{
    pass P0 {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main(); 
    }  
}

/*
//const float outlineWidth;
//const float outlineHeight;
//const float4 outlineColor, outlineBg;
const float2 samples[8] = {
-1.0,-1.0,
 0.0,-1.0,
 1.0,-1.0,
-1.0, 0.0,
 1.0, 0.0,
-1.0, 1.0,
 0.0, 1.0,
 1.0, 1.0,
};
*/
