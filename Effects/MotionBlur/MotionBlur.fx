sampler2D img;
float coeff;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    return tex2D(img,In)*float4(1,1,1,coeff);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }