sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    float4 bg = tex2D(bkd,In);
    float4 fg = tex2D(img,In);
    //float r = 255.0 * bg.r;
    //float g = 255.0 * bg.g;
    //float i = r + (256.0 * g);
    //float r2 = ((i % 1024) % 32) / 31.0;
    float i = (bg.r * 255.0) + (bg.g * 65280.0);
    float r2 = (i % 40) / 39.0;
    float g2 = ((i % 1600) / 40) / 39.0;
    float b2 = (i / 1600) / 39.0;
    float4 outrgba = float4( r2, g2, b2, 1.0);
    if ( fg.a > 0) {
       bg = outrgba;
    }
   return bg;
}

technique BgBlur { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }