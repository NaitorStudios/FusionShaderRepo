 
// Pixel shader input structure
struct PS_INPUT
{
	float4 Position	: POSITION;
	float2 texCoord	: TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
	float4 Color	: COLOR0;
};

//sampler2D Tex0;
uniform sampler2D uHeightMap;

//float2 vTextureCoord;
uniform float uXYAngle;
uniform float uZAngle;
//uniform int uMaxShadowSteps;
uniform float uTexStep;


//#ifdef GL_ES
//  precision highp float;
//#endif

float2 extrude(float2 other, float angle, float _length) {
  float x = _length * cos(angle);
  float y = _length * sin(angle);
  return float2(other.x + x, other.y + y);
}

float getHeightAt(float2 texCoord, float xyAngle, float _distance) {
  float2 newTexCoord = extrude(texCoord, xyAngle, _distance);
  return tex2D(uHeightMap, newTexCoord).r;
}

float getTraceHeight(float height, float zAngle, float _distance) {
  return _distance * tan(zAngle) + height;
}

bool isInShadow(float xyAngle, float zAngle, float2 texCoord, float _step) {
  float _distance;
  float height;
  float otherHeight;
  float traceHeight;
  bool result = false;
  height = tex2D(uHeightMap, texCoord).r;
  for(int i = 0; i < 100; ++i) {
    _distance = _step * float(i);
    otherHeight = getHeightAt(texCoord, xyAngle, _distance);
    if(otherHeight > height) {
      traceHeight = getTraceHeight(height, zAngle, _distance);
      if(traceHeight <= otherHeight) {
        result = true;
      }
    }
  }
  return result;
}


float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0 {
  //float4 background = tex2D(Tex0, texCoord);
  float alpha = 0.0;
  //if(isInShadow(uXYAngle, uZAngle, uHeightMap, uMaxShadowSteps, vTextureCoord, uTexStep)) {
  if(isInShadow(uXYAngle, uZAngle, texCoord, uTexStep)) {
    alpha = 0.5;
  }
  return float4(0, 0, 0, alpha);
}

// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader	= NULL;
		PixelShader		= compile ps_2_0 ps_main();
	}	
}