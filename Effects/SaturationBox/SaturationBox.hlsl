// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

cbuffer PS_VARIABLES : register(b0)
{
	int fHue;
	int fLightness;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float S = In.texCoord.x;
	float L = fLightness / 255.0;

	float _fHue = fHue * 360 / 255.0;	
	float C = (1- abs(2*L - 1)) * S;
	float X = C * (1- abs((( _fHue / 60) % 2.0) -1));
	float M = L-(C*0.5);
	
	if ( _fHue < 60 ) {
		Out.Color = float4(C+M,X+M,0+M,1);
		}
	
	else if ( _fHue < 120) {
		Out.Color = float4(X+M,C+M,0+M,1);
		}
	
	else if ( _fHue < 180) {
		Out.Color = float4(0+M,C+M,X+M,1);
		}
	
	else if ( _fHue < 240) {
		Out.Color = float4(0+M,X+M,C+M,1);
		}
	
	else if ( _fHue < 300) {
		Out.Color = float4(X+M,0+M,C+M,1);
		}
	
	else {
		Out.Color = float4(C+M,0+M,X+M,1);
		}
	
		return Out;
}


