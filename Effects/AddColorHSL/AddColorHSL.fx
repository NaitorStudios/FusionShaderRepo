
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
sampler2D bgTex : register(s1);

// PS_VARIABLES
float hue;
float saturation;
float lightness;
float semitransparency;
int inverted;

// Helper for hue2rgb
float fn(in int n, in float hue360, in float a) {
  float k = (n + hue360/30.0f) % 12.0f;
  return lightness - a * max(-1.0f, min(min(k - 3.0f, 9.0f - k), 1.0f));
}

// Convert a hue and the global saturation and lightness to an RGB color.
float3 hue2rgb() {
  float hue360 = hue * 360.0f;

  // Grayscale
  if (saturation == 0.0f)
    return lightness;
  else {
    float a = saturation * min(lightness, 1.0f - lightness);
    return float3(
      fn(0, hue360, a),
      fn(8, hue360, a),
      fn(4, hue360, a));
  }
}

PS_OUTPUT ps_main( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;

    float4 srcColor = tex2D(Tex0, In.Texture);
    float3 hsl = hue2rgb();
    float4 bg = tex2D(bgTex, In.Texture);

    Out.Color.rgba = float4((srcColor.r + hsl.r) * (1.0 - semitransparency) + bg.r * semitransparency,
                            (srcColor.g + hsl.g) * (1.0 - semitransparency) + bg.r * semitransparency,
                            (srcColor.b + hsl.b) * (1.0 - semitransparency) + bg.r * semitransparency,
                            srcColor.a);

    if (inverted != 0) {
      Out.Color.rgb = 1.0 - Out.Color.rgb;
    }

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
