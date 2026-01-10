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

float fLightness;
float fSaturation;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float S = fSaturation / 255.0;
	float L = fLightness / 255.0;
	float fHue = In.Texture.x*360.0;
	
float C = (1- abs(2*L - 1)) * S;
float X = C * (1- abs((( fHue / 60) % 2.0) -1));
float M = L-(C*0.5);

if ( fHue < 60 ) {
	Out.Color = float4(C+M,X+M,0+M,1);
	}

else if ( fHue < 120) {
	Out.Color = float4(X+M,C+M,0+M,1);
	}

else if ( fHue < 180) {
	Out.Color = float4(0+M,C+M,X+M,1);
	}

else if ( fHue < 240) {
	Out.Color = float4(0+M,X+M,C+M,1);
	}

else if ( fHue < 300) {
	Out.Color = float4(X+M,0+M,C+M,1);
	}

else {
	Out.Color = float4(C+M,0+M,X+M,1);
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
        PixelShader  = compile ps_2_a ps_main();
    }  
}