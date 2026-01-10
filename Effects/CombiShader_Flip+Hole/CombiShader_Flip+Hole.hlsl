
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

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	int iFlipX;
	int iFlipY;
	float fD;
	float fE;
	float fX;
	float fY;
	float fC;
	float fRatio;
	int iInvert;
	int iH;
	int iV;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    
    float2 flippedTexture = In.texCoord;
    if(iFlipX==1) flippedTexture.x = 1.0 - In.texCoord.x;
    if(iFlipY==1) flippedTexture.y = 1.0 - In.texCoord.y;
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, flippedTexture) * In.Tint);

    if(iH==0 || (iH==1 && flippedTexture.x >fX) || (iH==2 && flippedTexture.x <fX) ) {
    	if(iV==0 || (iV==1 && flippedTexture.y >fY) || (iV==2 && flippedTexture.y <fY) ) {
            float a = pow(max(0,min(1,sqrt(pow(flippedTexture.y-fY,2)/fRatio+pow(flippedTexture.x-fX,2)*fRatio)/fD)),fE)*fC;
            Out.Color.a *= (iInvert==1) ? 1-a : a;
        }
    }

    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    
    float2 flippedTexture = In.texCoord;
    if(iFlipX==1) flippedTexture.x = 1.0 - In.texCoord.x;
    if(iFlipY==1) flippedTexture.y = 1.0 - In.texCoord.y;
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, flippedTexture) * In.Tint);

    if(iH==0 || (iH==1 && flippedTexture.x >fX) || (iH==2 && flippedTexture.x <fX) ) {
    	if(iV==0 || (iV==1 && flippedTexture.y >fY) || (iV==2 && flippedTexture.y <fY) ) {
            float a = pow(max(0,min(1,sqrt(pow(flippedTexture.y-fY,2)/fRatio+pow(flippedTexture.x-fX,2)*fRatio)/fD)),fE)*fC;
            Out.Color.a *= (iInvert==1) ? 1-a : a;
        }
    }
	Out.Color.rgb *= Out.Color.a;

    return Out;
}

