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
int iScanline;

float iScanLineForca = 0.0;

float iCorVermelho = 2.0;
float iCorVerde = 2.0;
float iCorAzul = 2.0;

int iAberracao;
float iAberracaoDistortion = 0.003;
int iRadial;
float iRadialDistortion = 0.05;

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
		float r = tex2D(Tex0, texCoord - texCoordOffset).r; 
		float g = tex2D(Tex0, texCoord).g; 
		float b = tex2D(Tex0, texCoord + texCoordOffset).b; 
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
		float2 texCoordOffset = In.Texture.xy; 
		if( iRadial == 1 )
			texCoordOffset = radialDistortion( In.Texture.xy, In.Texture.xy );
		Out.Color = tex2D(Tex0, texCoordOffset);
		Out.Color = ScanLine( Out.Color, texCoordOffset );
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