// Card3D with Foil Effect
// v1.0
// By asker, inspired by Perspective3D by MuddyMole/Sketchy

sampler2D img = sampler_state {
	MinFilter = Linear;
	MagFilter = Linear;
	AddressU = Border;
	AddressV = Border;
	BorderColor = float4(0, 0, 0, 0);
};

sampler2D patternImg : register(s1);

float fX, fY, fZ, fDist, fZoom;
int foilType;
float foilMagnitude;
bool oneSided;

static const float RAD_TO_DEG = 3.14159265359f / 180.0f;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
	float dX = fX * RAD_TO_DEG;
	float dY = fY * RAD_TO_DEG;
	float dZ = fZ * RAD_TO_DEG;

	// Compute sin/cos values once
	float cx = cos(dX), sx = sin(dX);
	float cy = cos(dY), sy = sin(dY);
	float cz = cos(dZ), sz = sin(dZ);

	// 3x3 Rotation Matrix
	float3x3 rotMatrix = float3x3(
		cx * cz,	sy * sx * cz - cy * sz,	cy * sx * cz + sy * sz,
		cx * sz,	sy * sx * sz + cy * cz,	cy * sx * sz - sy * cz,
		-sx,		sy * cx,				cy * cx
	);

	// Offset pixel coordinates to center
	float3 p = mul(rotMatrix, float3(In - 0.5, 0.0)) + float3(0.5, 0.5, 0);

	// Transform camera position (0, 0, -fD) using the same matrix
	float3 c = mul(rotMatrix, float3(0.0, 0.0, -fDist)) + float3(0.5, 0.5, 0);

	// Compute intersection with z = 0 plane
	float2 xy = lerp(c.xy, p.xy, -c.z / (p.z - c.z));

	//Get the color from card image
	float4 cardColor = tex2D(img, ((xy - 0.5) / fZoom) + 0.5);
	//Get the color from pattern image
	float3 patternColor = tex2D(patternImg, ((xy - 0.5) / fZoom) + 0.5).rgb;

	//Approximate a rainbow coefficient based on card rotation and texel position
	float a = (dX + In.x) * 14.0 + (dY + In.y) * 7.0;
	float3 rainbow = float3(0.2 + (sin(a) + 1.0) * 0.4, 
							0.2 + (sin(a + 2.0) + 1.0) * 0.4, 
							0.2 + (sin(a + 4.0) + 1.0) * 0.4);
    if(cx * cy >= oneSided - 1) {
        if (foilType == 1) {
            cardColor.rgb += rainbow * 0.75 * patternColor * foilMagnitude;
        }
        else if (foilType == 2) {
            float strength = (1.0 - abs(dot(cardColor.rgb, float3(0.299, 0.587, 0.114)) - 0.5) * 2.0) //Foil effect is at its strongest (1.0) on colors at 50% brightness, white is 0.0 and black is 0.0
                * 0.75 * foilMagnitude; // lower the strength a bit and multiply by foil magnitude
            cardColor.rgb += (rainbow - cardColor.rgb) * strength;
        }
    }
	return cardColor;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}