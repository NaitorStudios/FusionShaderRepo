// Global variables
sampler2D img : register(s0) = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
};

float fHFOV, fVFOV, fXZoom, fYZoom, fX, fY;


float3 rotateXY(float3 p, float2 angle) {
	float2 c = cos(angle), s = sin(angle);
	p = float3(p.x, c.x*p.y + s.x*p.z, -s.x*p.y + c.x*p.z);
	return float3(c.y*p.x + s.y*p.z, p.y, -s.y*p.x + c.y*p.z);
}

float4 ps_main(in float2 fragCoord : TEXCOORD0) : COLOR0 {
	float PI = 3.14159265;
	float2 iResolution = float2(fXZoom, fYZoom), iMouse = float2(fX, fY);
	//place 0,0 in center from -1 to 1 ndc
	float2 uv = fragCoord.xy * 2/iResolution.xy - 1;
	
	//to spherical
	float3 camDir = normalize(float3(uv.xy * float2(tan(0.5 * fHFOV * PI / 180), tan(0.5 * fVFOV * PI / 180)), 1));
	
	//camRot is angle vec in rad
	float3 camRot = float3( (iMouse.xy / iResolution.xy - 0.5) * float2(2.0 * PI,  PI), 0);
	
	//rotate
	float3 rd = normalize(rotateXY(camDir, camRot.yx));
	float2 texCoord;
	//radial azmuth polar
	if(rd.x > 0)
		texCoord = float2(atan(rd.z / rd.x) +  PI / 2, acos(-rd.y)) / float2(2 * PI, PI);
	else
		texCoord = float2(atan(rd.z / rd.x) +  3 * PI / 2, acos(-rd.y)) / float2(2 * PI, PI);
	
	float4 fragColor = tex2D(img, texCoord);
	
	// Uncomment to visualize input
	//fragColor = texture(iChannel0, fragCoord.xy/iResolution.xy);
	return fragColor;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_b ps_main(); }}