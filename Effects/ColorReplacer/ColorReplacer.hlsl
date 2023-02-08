struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 R;
	float4 G;
	float4 B;
	float4 C;
	float4 M;
	float4 Y;
	float4 T;
	float4 P;
	float4 O;
};

static const float HALF = 128.0/255;

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 o = img.Sample(imgSampler, In.texCoord) * In.Tint;
	
	if(o.r == 1)
	{
		if(o.g == 1)
		{
			if(o.b == 0)
				o.rgb = Y.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = M.rgb;
			else if(o.b == 0)
				o.rgb = R.rgb;
		}
	}
	else if(o.r == 0)
	{
		if(o.g == 1)
		{
			if(o.b == 1)
				o.rgb = C.rgb;
			else if(o.b == 0)
				o.rgb = G.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = B.rgb;
		}
		else if(o.g == HALF && o.b == HALF)
		{
			o.rgb = T.rgb;
		}
	}
	else if(o.r == HALF)
	{	
		if(o.g == 0 && o.b == HALF)
		{
			o.rgb = P.rgb;
		}	
		else if(o.g == HALF && o.b == 0)
		{
			o.rgb = O.rgb;
		}
	}
	
	return o;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 o = img.Sample(imgSampler, In.texCoord) * In.Tint;
	if ( o.a != 0 )
		o.rgb /= o.a;
	
	if(o.r == 1)
	{
		if(o.g == 1)
		{
			if(o.b == 0)
				o.rgb = Y.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = M.rgb;
			else if(o.b == 0)
				o.rgb = R.rgb;
		}
	}
	else if(o.r == 0)
	{
		if(o.g == 1)
		{
			if(o.b == 1)
				o.rgb = C.rgb;
			else if(o.b == 0)
				o.rgb = G.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = B.rgb;
		}
		else if(o.g == HALF && o.b == HALF)
		{
			o.rgb = T.rgb;
		}
	}
	else if(o.r == HALF)
	{	
		if(o.g == 0 && o.b == HALF)
		{
			o.rgb = P.rgb;
		}	
		else if(o.g == HALF && o.b == 0)
		{
			o.rgb = O.rgb;
		}
	}
	
	o.rgb *= o.a;
	return o;
}
