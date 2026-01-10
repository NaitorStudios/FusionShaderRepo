sampler2D img;
int absolute;
float x,y,sampleDist,sampleStrength,scale,fPixelWidth,fPixelHeight;

float samples[] = {-0.08,-0.05,-0.03,-0.02,-0.01,0.01,0.02,0.03,0.05,0.08};

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{ 
	float2 relative = 1.0;
	if(absolute)
		relative = float2(fPixelWidth,fPixelHeight);

	float2 dir = float2(x,y)*relative-In;
	float dist = sqrt(dir.x*dir.x+dir.y*dir.y);
	dir /= dist;

    float4 color = tex2D(img,In), sum = color;
    
    for(int i =0; i<10 ; i++)
        sum += tex2D(img, In + dir*samples[i]*sampleDist*relative);
    sum /= 11.0;
    
    float t = dist*sampleStrength;
    t = clamp(t,0,1);
    
    return lerp(color,sum,t);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }