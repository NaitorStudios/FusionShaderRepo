
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

// Global variables
cbuffer PS_VARIABLES : register(b0)
{
	// Amount to shift the Hue, range 0 to 6
	float Hue;
	float Saturation;
	float Lightness;
	float Contrast;
};


float3x3 QuaternionToMatrix(float4 quat)
{
    float3 cross = quat.yzx * quat.zxy;
    float3 square= quat.xyz * quat.xyz;
    float3 wimag = quat.w * quat.xyz;

    square = square.xyz + square.yzx;

    float3 diag = 0.5 - square;
    float3 a = (cross + wimag);
    float3 b = (cross - wimag);

    return float3x3(
    2.0 * float3(diag.x, b.z, a.y),
    2.0 * float3(a.z, diag.y, b.x),
    2.0 * float3(b.y, a.x, diag.z));
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721);
	
    float4 outputColor = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint);
    float3 hsv; 
    float3 intensity;           
        float3 root3 = float3(0.57735, 0.57735, 0.57735);
        float half_angle = 0.5 * radians(Hue); // Hue is radians of 0 tp 360 degree
        float4 rot_quat = float4( (root3 * sin(half_angle)), cos(half_angle));
        float3x3 rot_Matrix = QuaternionToMatrix(rot_quat);     
        outputColor.rgb = mul(rot_Matrix, outputColor.rgb);
        outputColor.rgb = (outputColor.rgb - 0.5) *(Contrast + 1.0) + 0.5;  
        outputColor.rgb = outputColor.rgb + Lightness;         
        intensity = float(dot(outputColor.rgb, lumCoeff));
        outputColor.rgb = lerp(intensity, outputColor.rgb, Saturation );            

    return outputColor;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721);
	
    float4 outputColor = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint);
    float3 hsv; 
    float3 intensity;           
        float3 root3 = float3(0.57735, 0.57735, 0.57735);
        float half_angle = 0.5 * radians(Hue); // Hue is radians of 0 tp 360 degree
        float4 rot_quat = float4( (root3 * sin(half_angle)), cos(half_angle));
        float3x3 rot_Matrix = QuaternionToMatrix(rot_quat);     
        outputColor.rgb = mul(rot_Matrix, outputColor.rgb);
        outputColor.rgb = (outputColor.rgb - 0.5) *(Contrast + 1.0) + 0.5;  
        outputColor.rgb = outputColor.rgb + Lightness;         
        intensity = float(dot(outputColor.rgb, lumCoeff));
        outputColor.rgb = lerp(intensity, outputColor.rgb, Saturation );    

	outputColor.rgb *= outputColor.a;

    return outputColor;
}

