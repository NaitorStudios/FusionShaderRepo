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
sampler2D fImage : register(s1); 
sampler2D fBorderImage : register(s2); 
sampler2D fBackgroundImage : register(s3); 
float fValue;
bool fBoolBorder;
bool fBoolBackground;
bool fBoolDraw;

// Blend coefficient

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 gradient = tex2D(fImage,In.Texture);
    float4 bg = tex2D(fBackgroundImage,In.Texture);
    float4 border = tex2D(fBorderImage,In.Texture);
    Out.Color = tex2D(Tex0, In.Texture);
    float result = (gradient.r + gradient.g + gradient.b)/3.0;
    if ( result < 1.0 - fValue) {
		if ( fBoolBackground == true ) {
			Out.Color = bg;
		} else {
			Out.Color.a = 0;
		}
    }
    if ( fBoolDraw == true ) {
		float4 back;
		back.r = ( bg.r * bg.a * (1.0 - Out.Color.a) + Out.Color.r * Out.Color.a );
		back.g = ( bg.g * bg.a * (1.0 - Out.Color.a) + Out.Color.g * Out.Color.a );
		back.b = ( bg.b * bg.a * (1.0 - Out.Color.a) + Out.Color.b * Out.Color.a );
		back.a = (bg.a* ( 1.0 - Out.Color.a ) + Out.Color.a );
		Out.Color = back;
    }
    if ( fBoolBorder == true ) {
		float4 join;
		join.r = ( border.r * border.a + Out.Color.r * Out.Color.a * (1.0 - border.a) );
		join.g = ( border.g * border.a + Out.Color.g * Out.Color.a * (1.0 - border.a) );
		join.b = ( border.b * border.a + Out.Color.b * Out.Color.a * (1.0 - border.a) );
		join.a = ( border.a + Out.Color.a * ( 1.0 - border.a ) );
		Out.Color = join;
    }
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