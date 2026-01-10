bool vert;
float center;
float counter;
int dir;
float4 color1;
float4 color2;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0
{
    float gradient= vert ? texCoord.y/center : texCoord.x/center;
    float4 output=lerp(color1,color2,gradient);

    if(dir==0)
    {
        output*= float4(texCoord.x < counter, texCoord.x < counter, texCoord.x < counter, texCoord.x < counter);
    }
    if(dir==1)
    {
        output*= float4(texCoord.x > 1.0-counter, texCoord.x > 1.0-counter, texCoord.x > 1.0-counter, texCoord.x > 1.0-counter);
    }
    if(dir==2)
    {
        output*= float4(texCoord.y < counter, texCoord.y < counter, texCoord.y < counter, texCoord.y < counter);
    }
    if(dir==3)
    {
        output*= float4(texCoord.y > 1.0-counter, texCoord.y > 1.0-counter, texCoord.y > 1.0-counter, texCoord.y > 1.0-counter);
    }
    return output;
}

technique tech_main { pass P0 {PixelShader  = compile ps_2_0 ps_main();}}