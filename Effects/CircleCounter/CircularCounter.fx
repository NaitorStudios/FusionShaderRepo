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

float fCenter;
float fWidth;
float fEdge;
float fVal;
float fMin;
float fMax;


PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
float normValue = (fVal - fMin)	/ (fMax - fMin);
float angleFromCenter = (atan2( In.Texture.x-0.5, In.Texture.y-0.5)+3.142)/(2*3.142);  
float hue = angleFromCenter * 360 / 3.0;
float X = (1 - abs(((hue / 60.0) % 2.0) - 1));

if ( hue < 60 ) {
	Out.Color = float4(1,X,0,1);
	}

else if ( hue < 120) {
	Out.Color = float4(X,1,0,1);
	}

else if ( hue < 180) {
	Out.Color = float4(0,1,X,1);
	}

else if ( hue < 240) {
	Out.Color = float4(0,X,1,1);
	}

else if ( hue < 300) {
	Out.Color = float4(X,0,1,1);
	}

else {
	Out.Color = float4(1,0,X,1);
	}

float dist = pow(pow(In.Texture.x-0.5, 2)+pow(In.Texture.y-0.5, 2), 0.5);

float inEdge = fCenter - (fWidth*0.5);
float outEdge = fCenter + (fWidth*0.5);

if ( dist < inEdge + fEdge && dist < fCenter ) {
	Out.Color.a = ((dist - inEdge)/fEdge)*10;
	}

if ( dist > outEdge - fEdge && dist > fCenter ) {
	Out.Color.a = ((outEdge - dist)/fEdge)*10;
	}

if (normValue < angleFromCenter) {
	Out.Color.a = 0;
	}

/*
if ( dist < 0.35 || dist > 0.45 ) {
	Out.Color = float4(0,0,0,0);
	}
*/
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