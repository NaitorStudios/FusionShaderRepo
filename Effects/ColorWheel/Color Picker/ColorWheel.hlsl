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
	float fWidth;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    // Output pixel
    float4 Out;
	
	float hue = 360*(atan2( In.texCoord.x-0.5, In.texCoord.y-0.5)+3.142)/(2*3.142);  
	
	float X = (1 - abs(((hue / 60.0) % 2.0) - 1));
	
	if ( hue < 60 ) {
		Out = float4(1,X,0,1);
		}
	
	else if ( hue < 120 ) {
		Out = float4(X,1,0,1);
		}
	
	else if ( hue < 180 ) {
		Out = float4(0,1,X,1);
		}
	
	else if ( hue < 240 ) {
		Out = float4(0,X,1,1);
		}
	
	else if ( hue < 300 ) {
		Out = float4(X,0,1,1);
		}
	
	else {
		Out = float4(1,0,X,1);
		}
	
	float dist = pow(pow(In.texCoord.x-0.5, 2)+pow(In.texCoord.y-0.5, 2), 0.5);
	float inEdge = 0.5 - fWidth;
	float outEdge = 0.5;
	float margin = ((fPixelWidth + fPixelHeight) * 0.5);
	if ( dist < inEdge + margin && dist > inEdge ) {
		Out.a = (dist - inEdge) / margin;
	} else if ( dist > outEdge - margin && dist < outEdge ) {
		Out.a = (outEdge - dist) / margin;
	} else if ( dist > outEdge || dist < inEdge ) {
		Out.a = 0.0;
	}
    return Out;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    // Output pixel
    float4 Out;
	
	float hue = 360*(atan2( In.texCoord.x-0.5, In.texCoord.y-0.5)+3.142)/(2*3.142);  
	
	float X = (1 - abs(((hue / 60.0) % 2.0) - 1));
	
	if ( hue < 60 ) {
		Out = float4(1,X,0,1);
		}
	
	else if ( hue < 120 ) {
		Out = float4(X,1,0,1);
		}
	
	else if ( hue < 180 ) {
		Out = float4(0,1,X,1);
		}
	
	else if ( hue < 240 ) {
		Out = float4(0,X,1,1);
		}
	
	else if ( hue < 300 ) {
		Out = float4(X,0,1,1);
		}
	
	else {
		Out = float4(1,0,X,1);
		}
	
	float dist = pow(pow(In.texCoord.x-0.5, 2)+pow(In.texCoord.y-0.5, 2), 0.5);
	float inEdge = 0.5 - fWidth;
	float outEdge = 0.5;
	float margin = ((fPixelWidth + fPixelHeight) * 0.5);
	if ( dist < inEdge + margin && dist > inEdge ) {
		Out.a = (dist - inEdge) / margin;
	} else if ( dist > outEdge - margin && dist < outEdge ) {
		Out.a = (outEdge - dist) / margin;
	} else if ( dist > outEdge || dist < inEdge ) {
		Out.a = 0.0;
	}
	Out.rgb *= Out.a;
    return Out;
}

