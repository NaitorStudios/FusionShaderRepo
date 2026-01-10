struct PS_INPUT{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT {
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t1);
sampler imgSampler : register(s1);

cbuffer PS_PIXELSIZE : register(b1) {
	float fPixelWidth;
	float fPixelHeight;
};

cbuffer PS_VARIABLES : register(b0) {
	int width;
	int height;
	float quality;
	float colorblur;
	float scanlines;
	float horizontalblur;
	float fringing;
	float edges;
	float colorbanding;
	float sharpening;
	bool invertfringe;
}

float GetEdge(float x) {
	if(edges <= 0) return 1;

	if(x > .5)
		return min((width-x*width)*(4/edges),1);
	
	return min(x*width*(4/edges),1);
}

float4 GetBlur(float2 uv, float amount, float priority) {
	float q = quality*1.5;
	if(amount <= 0 || (q*.5+.4) <= (1 - priority)) {
		return img.Sample(imgSampler,uv);
	} else if((q-.5) <= (1 - priority)) {
		return (
			img.Sample(imgSampler,uv                      )+
			img.Sample(imgSampler,uv+float2( amount*.5 ,0))+
			img.Sample(imgSampler,uv+float2( amount    ,0))+
			img.Sample(imgSampler,uv+float2(-amount*.5 ,0))+
			img.Sample(imgSampler,uv+float2(-amount    ,0)))/5;
	} else {
		return (
			img.Sample(imgSampler,uv                      )+
			img.Sample(imgSampler,uv+float2( amount*.25,0))+
			img.Sample(imgSampler,uv+float2( amount*.5 ,0))+
			img.Sample(imgSampler,uv+float2( amount*.75,0))+
			img.Sample(imgSampler,uv+float2( amount    ,0))+
			img.Sample(imgSampler,uv+float2(-amount*.25,0))+
			img.Sample(imgSampler,uv+float2(-amount*.5 ,0))+
			img.Sample(imgSampler,uv+float2(-amount*.75,0))+
			img.Sample(imgSampler,uv+float2(-amount    ,0)))/9;
	}
}

float GetBandChannel(float x) {
	float i = x%3;
	if(i>2) return -.25;
	return .25-cos(i*3.14159265359)*.5;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	float2 uv = In.texCoord;

	float squiggle = (uv.y*height)%2;
	if(squiggle > 1) squiggle = 2-squiggle;
	squiggle = min(max((squiggle-.5)/(fPixelHeight*height),-.5),.5);

	//edge
	float edge = GetEdge(uv.x);

	//horizontal blur
	float bluramount = (horizontalblur*5)/width;
	float4 c = GetBlur(uv,bluramount,fringing>0?.5:.7)*edge;

	//fringing
	if(fringing > 0) {
		uv.x += (squiggle*(invertfringe?1:-1)*(c.r-c.g)*fringing*10)/width;
		edge = GetEdge(uv.x);
		c = GetBlur(uv,bluramount,.7)*edge;
	}

	//sharpening
	float hpix = 1./height;
	float wpix = 1./width;
	c = (4*c-((
		GetBlur(uv+float2(0, hpix),bluramount,.2)+
		GetBlur(uv+float2(0,-hpix),bluramount,.2))*edge+
		GetBlur(uv+float2( wpix,0),bluramount,.1)*GetEdge(uv.x+wpix)+
		GetBlur(uv+float2(-wpix,0),bluramount,.1)*GetEdge(uv.x-wpix)))*sharpening + c;

	//color blur
	float desaturated = (c.r+c.g+c.b)*.3333333;
	float3 blurred;
	if(colorblur > 0) {
		blurred = GetBlur(uv,(colorblur*25)/width,.9).rgb;
		blurred -= (blurred.r+blurred.g+blurred.b)*.3333333;
		c = float4(desaturated+blurred,c.a);
	} else {
		blurred = c.rgb-desaturated;
	}

	//color banding
	if(colorbanding > 0) {
		float banduv = (uv.x*3)*.03125*width+(invertfringe?3:2);
		c = float4(float3(
			GetBandChannel(banduv  ),
			GetBandChannel(banduv+1),
			GetBandChannel(banduv+2))*(
			abs(blurred.r)+
			abs(blurred.g)+
			abs(blurred.b))
			*colorbanding+blurred*(1-colorbanding)+desaturated,1.);
	}

	//scanlines
	if(scanlines > 0) {
		if(desaturated > .5)
			c = 1-(1-c)*(1-squiggle*scanlines);
		else
			c *= (1+squiggle*scanlines);
	}

	return c * In.Tint;
}
