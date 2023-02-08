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

// Global variables

sampler2D Tex0;
sampler2D oi : register(s1);
float xoff,yoff,width,height,fPixelWidth,fPixelHeight;
float X1,Y1,T1;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	float2 shiftcoor = float2(fmod((In.Texture.x + xoff*fPixelWidth),1),fmod((In.Texture.y + yoff*fPixelHeight),1));
	float4 shift = tex2D(oi,shiftcoor);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5);
	off.y *= 2*(shift.g-0.5);
	Out.Color = tex2D(Tex0,In.Texture+off);
	off.x *= 6*T1*(shift.r-0.5);
	off.y *= 6*T1*(shift.g-0.5);
	float dist1 = distance(float2(X1,Y1),In.Texture+off) * 2;
	dist1 = (sin((T1/2-dist1)*(T1*16+20))*0.5+0.5) * sqrt(max(T1*0.8-dist1,0))+max(T1*0.8-dist1,0);
	Out.Color.a -= dist1;

    return Out;
}

technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}