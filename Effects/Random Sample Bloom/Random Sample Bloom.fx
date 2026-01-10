sampler2D img;
sampler2D bg : register(s1);
float radius,thresh,multiplier,fPixelWidth,fPixelHeight;


//This shader is currently only DX11. This DX9 version does nothing.



float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    float4 s = tex2D(img,In);

    return s;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }