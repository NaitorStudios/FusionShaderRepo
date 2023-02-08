
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

// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	int iScanline;
	float iScanLineForca = 0.0;

	int iAberracao;
	float iAberracaoDistortion = 0.003;

	float iCorVermelho = 2.0;
	float iCorVerde = 2.0;
	float iCorAzul = 2.0;

	int iRadial;
	float iRadialDistortion = 0.05;
};

float2 radialDistortion(float2 coord, float2 pos) 
{ 
    float distortion = iRadialDistortion; 
    float2 cc = pos - 0.5; 
    float dist = dot(cc, cc) * distortion; 
	
	return coord * (pos + cc * (1.0 + dist) * dist) / pos; 
} 

float4 ScanLine(float4 color: COLOR0, float2 texCoord : TEXCOORD0) : COLOR0 
{ 
    // aberração cromática 
	float4 imageColor = color;
	if( iAberracao == 1 ) {
		float2 texCoordOffset = float2(iAberracaoDistortion, 0); 
		float r = Texture0.Sample(TextureSampler0, texCoord - texCoordOffset).r; 
		float g = Texture0.Sample(TextureSampler0, texCoord).g; 
		float b = Texture0.Sample(TextureSampler0, texCoord + texCoordOffset).b; 
		imageColor = float4(r,g,b,1); 
		imageColor = float4(r*iCorVermelho,g*iCorVerde,b*iCorAzul,1); 
 	} 
	
    // scanline 
	float4 scalineColor = float4(1,1,1,1);
	if( iScanline == 1 ) {
    	scalineColor = 1.2 * float4(1,1,1,1) * abs(sin(texCoord.y * 2000)); 
		
		scalineColor += iScanLineForca;
		if( scalineColor.r > 1.0 )
			scalineColor.r = 1.0;

	}
 
    // combina tudo e fecha
    //return color * imageColor * scalineColor; 
    return imageColor * scalineColor; 
} 

PS_OUTPUT ps_main( in PS_INPUT In )
{
	  // Output pixel
	PS_OUTPUT Out;
		float2 texCoordOffset = In.texCoord.xy; 
		if( iRadial == 1 )
			texCoordOffset = radialDistortion( In.texCoord.xy, In.texCoord.xy );
		Out.Color = Texture0.Sample(TextureSampler0, texCoordOffset);
		Out.Color = ScanLine( Out.Color, texCoordOffset ) * In.Tint;
	return Out;
}
