sampler2D img : register(s0);

bool flipX, flipY;

//Main Shader Function
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {

    float2 uv = float2(In);
    float4 color;

    if(flipX){
        uv.x = 1.0 - In.x;
    }

    if(flipY){
        uv.y = 1.0 - In.y;
    }
    
    color = tex2D(img, float2(uv));
    return color;

}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }