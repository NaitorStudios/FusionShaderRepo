
// Pixel shader input structure
struct PS_INPUT {
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT {
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;

// PS_VARIABLES
float4 black;
float4 grey;
float4 white;
float offset;

// Helper for hue2rgb
float fn(in int n, in float hue360, in float a, in float lightness) {
  float k = (n + hue360/30.0f) % 12.0f;
  return lightness - a * max(-1.0f, min(min(k - 3.0f, 9.0f - k), 1.0f));
}

// Convert an HSL color to an RGB color.
float3 hsl2rgb(in float3 hsl) {
  float hue = hsl.r;
  float saturation = hsl.g;
  float lightness = hsl.b;

  float hue360 = hue * 360.0f;

  // Grayscale
  if (saturation == 0.0f)
    return lightness;
  else {
    float a = saturation * min(lightness, 1.0f - lightness);
    return float3(
      fn(0, hue360, a, lightness),
      fn(8, hue360, a, lightness),
      fn(4, hue360, a, lightness));
  }
}

// Convert an RGB color to an HSL color.
float3 rgb2hsl(in float3 rgb) {
  float m = min(rgb.r, min(rgb.g, rgb.b));
  float M = max(rgb.r, max(rgb.g, rgb.b));
  float chroma = M - m;

  float hue = 0.0f;
  if (chroma != 0.0f) {
    if (M == rgb.r) {
      hue = ((rgb.g - rgb.b) / chroma) % 6.0f;
    }
    else if (M == rgb.g) {
      hue = ((rgb.b - rgb.r) / chroma) + 2.0f;
    }
    else {
      hue = ((rgb.r - rgb.g) / chroma) + 4.0f;
    }
    hue /= 6.0f;
  }

  float lightness = (M + m) / 2.0f;
  float saturation = 0.0f;
  if (lightness > 0.0f && lightness < 1.0f) {
    saturation = chroma / (1.0f - abs(2.0f * lightness - 1.0f));
  }

  return float3(hue, saturation, lightness);
}

PS_OUTPUT ps_main( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;

    float4 srcColor = tex2D(Tex0, In.Texture);
    float alpha = (srcColor.r + offset) % 1.0f;

    float3 blackHSL = rgb2hsl(black.rgb);
    float3 greyHSL = rgb2hsl(grey.rgb);
    float3 whiteHSL = rgb2hsl(white.rgb);

    float3 midHSL;
    if (alpha < 0.5f) {
      alpha *= 2.0f;
      midHSL = ((1.0f - alpha) * blackHSL) + (alpha * greyHSL);
    }
    else {
      alpha = (alpha - 0.5f) * 2.0f;
      midHSL = ((1.0f - alpha) * greyHSL) + (alpha * whiteHSL);
    }
    float3 midRGB = hsl2rgb(midHSL);

    Out.Color.rgba = float4(midRGB, srcColor.a);
    return Out;
}

// Effect technique
technique tech_main {
    pass P0 {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }
}
