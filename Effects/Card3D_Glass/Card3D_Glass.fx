// Card3D with Glass Effect
// v1.0
// By asker, inspired by Perspective3D by MuddyMole/Sketchy

sampler2D img = sampler_state {
	MinFilter = Linear;
	MagFilter = Linear;
	AddressU = Border;
	AddressV = Border;
	BorderColor = float4(0, 0, 0, 0);
};

sampler2D bkd : register(s1);

float fX, fY, fZ, fDist, fZoom;
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
		cx * cz,    sy * sx * cz - cy * sz,   cy * sx * cz + sy * sz,
		cx * sz,    sy * sx * sz + cy * cz,   cy * sx * sz - sy * cz,
		-sx,        sy * cx,                  cy * cx
	);

	// Offset pixel coordinates to center
	float3 p = mul(rotMatrix, float3(In - 0.5, 0.0)) + float3(0.5, 0.5, 0);

	// Transform camera position (0, 0, -fD) using the same matrix
	float3 c = mul(rotMatrix, float3(0.0, 0.0, -fDist)) + float3(0.5, 0.5, 0);

	// Compute intersection with z = 0 plane
	float2 xy = lerp(c.xy, p.xy, -c.z / (p.z - c.z));

	//Get the color from card image
	float4 cardColor = tex2D(img, ((xy - 0.5) / fZoom) + 0.5);
    if(cx * cy >= oneSided - 1) { //If one-sided, only apply effect from the front (when cos(x) * cos(y) >= 0)
        float3 enhancedColor = pow(cardColor.rgb, 1.3) * 2.0; // Intensify colors
        float brightness = dot(enhancedColor, float3(0.299, 0.587, 0.114));
        float alpha = cardColor.a * (1.0 - smoothstep(0.9, 1.0, brightness)*0.5);
        float glare = smoothstep(0.1, 0.4, brightness) * saturate(cos((dX + In.x) * 8.0 + (dY + In.y) * 5.0));
        float blurOffset = alpha * 0.002; //The more opaque, the higher the blur
        //Get the color from the background
        float4 bkdColor = (tex2D(bkd, In) +
					 tex2D(bkd, In + float2(-blurOffset, -blurOffset)) + 
					 tex2D(bkd, In + float2(blurOffset, -blurOffset)) +
					 tex2D(bkd, In + float2(blurOffset, blurOffset)) + 
					 tex2D(bkd, In + float2(-blurOffset, blurOffset))) * 0.2;
        cardColor = float4(bkdColor.rgb * enhancedColor.rgb + glare * 0.3, alpha);
    }
    return cardColor;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}