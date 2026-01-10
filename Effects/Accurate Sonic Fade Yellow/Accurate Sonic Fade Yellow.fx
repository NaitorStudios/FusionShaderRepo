sampler2D Texture0;
float FadeTransition;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{ 
    //Variables
    float4 Col = tex2D(Texture0, In);
    float transition;
                
    //Change transition value
    transition = FadeTransition * 0.03;

    //Change the colors 
    Col.r = clamp(transition, 0, Col.r); // Adjust the red channel
    Col.g = clamp(transition, 0, Col.g); // Adjust the green channel
    Col.b = clamp(transition + Col.r + Col.g, 0, Col.b); // Adjust the blue channel
    return Col;
}

technique Shader { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }
