sampler2D bg : register(s1) = sampler_state {MinFilter = linear; MagFilter = linear; AddressU = border; AddressV = border; BorderColor = float4(0.0,0.0,0.0,1.0);};

float zoom;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0 {
    texCoord = (texCoord-0.5)/zoom+0.5;
    return tex2D(bg, texCoord);
}

technique tech_main{pass P0{PixelShader = compile ps_2_0 ps_main();}}