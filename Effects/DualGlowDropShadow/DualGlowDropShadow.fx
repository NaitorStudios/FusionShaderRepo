sampler2D img;
float fPixelWidth, fPixelHeight;
float iRadius, iExponent, oRadius, oExponent, oAlpha;
float sX, sY, sAngle, sAlpha;
float4 iColor, oColor, sColor;

const float2 offsets[12] = {
   -0.326212, -0.305805,
   -0.840144,  0.073580,
   -0.695914,  0.557137,
   -0.203345,  0.720716,
    0.962340, -0.094983,
    0.473434, -0.380026,
    0.519456,  0.867022,
    0.185461, -0.793124,
    0.507431,  0.164425,
    0.896420,  0.512458,
   -0.321940, -0.832615,
   -0.791559, -0.497705,
};

// Function to calculate shadow position based on the offset and angle
float2 getshadowxy(float2 In) {
    float2 pixel;
    if (sAngle != 0) {
        float theta = sAngle / 180.0 * 3.14159;
        float2 point = float2(cos(theta) * sX - sin(theta) * sY, sin(theta) * sX + cos(theta) * sY);
        pixel = In - float2(point.x * fPixelWidth, point.y * fPixelHeight);
    } else {
        pixel = In - float2(sX * fPixelWidth, sY * fPixelHeight);
    }
    return pixel;
}

// Pass 1: Render only the shadow
float4 ps_shadow(float2 In : TEXCOORD0) : COLOR0 {
    float2 shadowCoord = getshadowxy(In);
    float4 shadow = float4(0.0, 0.0, 0.0, 0.0); // Default shadow color with no alpha
    
    // Check if shadow coordinates are within valid texture bounds
    if (shadowCoord.x >= 0 && shadowCoord.x <= 1 && shadowCoord.y >= 0 && shadowCoord.y <= 1) {
        float4 texSample = tex2D(img, shadowCoord); // Sample the image at the shadow position
        shadow = sColor; // Use the shadow color
        shadow.a = texSample.a * sAlpha; // Apply shadow alpha based on texture transparency
    }
    
    return shadow; // Return the shadow result
}

// Pass 2: Render the object with dual glow
float4 ps_object_glow(float2 In : TEXCOORD0) : COLOR0 {
    float4 fore = tex2D(img, In); // Original image color
    float glow;

    // Inner Glow
    glow = fore.a;
    for (int i = 0; i < 12; i++) {
        glow += tex2D(img, In + iRadius * float2(fPixelWidth, fPixelHeight) * offsets[i]).a;
    }
    glow /= 13;

    // Blend between inner glow color and foreground based on blurred alpha
    fore.rgb = lerp(iColor.rgb, fore.rgb, pow(glow, iExponent));

    // Outer Glow
    glow = fore.a;
    for (int i = 0; i < 12; i++) {
        glow += tex2D(img, In + oRadius * float2(fPixelWidth, fPixelHeight) * offsets[i]).a;
    }
    glow /= 13;

    // Fill transparent areas with outer glow color
    fore.rgb = lerp(oColor.rgb, fore.rgb, fore.a);
    fore.a = max((1 - pow(1 - glow, oExponent)) * oAlpha, fore.a);

    return fore; // Return the object with glow
}

technique CombinedEffect {
    // Pass 1: Render only the shadow
    pass ShadowPass {
        PixelShader = compile ps_2_0 ps_shadow();
    }

    // Pass 2: Render the object with the dual glow
    pass ObjectGlowPass {
        PixelShader = compile ps_2_0 ps_object_glow();
    }
}
