
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
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float rX,rY,rW,rH,gX,gY,gW,gH,bX,bY,bW,bH;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 texClip(Texture2D<float4> img, sampler imgSampler, float2 pos, float4 tint)
{
	return (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1) ? 0 : img.Sample(imgSampler,pos) * tint;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color;
	float2 Pixel = float2(fPixelWidth,fPixelHeight);
	
	float2 redCoord   = float2((In.texCoord.x+0.5*(rW-1.0f)-(rX*fPixelWidth)) /rW,
							   (In.texCoord.y+0.5*(rH-1.0f)-(rY*fPixelHeight))/rH);
							   
	float2 greenCoord = float2((In.texCoord.x+0.5*(gW-1.0f)-(gX*fPixelWidth)) /gW,
							   (In.texCoord.y+0.5*(gH-1.0f)-(gY*fPixelHeight))/gH);
							   
	float2 blueCoord  = float2((In.texCoord.x+0.5*(bW-1.0f)-(bX*fPixelWidth)) /bW,
							   (In.texCoord.y+0.5*(bH-1.0f)-(bY*fPixelHeight))/bH);
	
	color.r = texClip(img,imgSampler,redCoord  , In.Tint).r;
	color.g = texClip(img,imgSampler,greenCoord, In.Tint).g;
	color.b = texClip(img,imgSampler,blueCoord , In.Tint).b;
	
	color.a  = texClip(img,imgSampler,redCoord  , In.Tint).a / 3.0;
	color.a += texClip(img,imgSampler,greenCoord, In.Tint).a / 3.0;
	color.a += texClip(img,imgSampler,blueCoord , In.Tint).a / 3.0;

	return color;
}

float4 texClip_pm(Texture2D<float4> img, sampler imgSampler, float2 pos, float4 tint)
{
	if (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1)
		return 0;
	float4 color = img.Sample(imgSampler,pos) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color;
	float2 Pixel = float2(fPixelWidth,fPixelHeight);
	
	float2 redCoord   = float2((In.texCoord.x+0.5*(rW-1.0f)-(rX*fPixelWidth)) /rW,
							   (In.texCoord.y+0.5*(rH-1.0f)-(rY*fPixelHeight))/rH);
							   
	float2 greenCoord = float2((In.texCoord.x+0.5*(gW-1.0f)-(gX*fPixelWidth)) /gW,
							   (In.texCoord.y+0.5*(gH-1.0f)-(gY*fPixelHeight))/gH);
							   
	float2 blueCoord  = float2((In.texCoord.x+0.5*(bW-1.0f)-(bX*fPixelWidth)) /bW,
							   (In.texCoord.y+0.5*(bH-1.0f)-(bY*fPixelHeight))/bH);
	
	color.r = texClip_pm(img,imgSampler,redCoord  , In.Tint).r;
	color.g = texClip_pm(img,imgSampler,greenCoord, In.Tint).g;
	color.b = texClip_pm(img,imgSampler,blueCoord , In.Tint).b;
	
	color.a  = texClip_pm(img,imgSampler,redCoord  , In.Tint).a / 3.0;
	color.a += texClip_pm(img,imgSampler,greenCoord, In.Tint).a / 3.0;
	color.a += texClip_pm(img,imgSampler,blueCoord , In.Tint).a / 3.0;

	color.rgb *= color.a;
	return color;
}
