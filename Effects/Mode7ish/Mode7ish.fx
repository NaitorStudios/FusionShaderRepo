
// Pixel shader input structure
struct PS_INPUT {
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT {
    float4 Color   : COLOR0;
};

static const float PI = 3.14159265f;

// Global variables
sampler2D Tex0; // Used as backdrop, which is only visible through transparent pixels of srcImage.
sampler2D srcImage : register(s1);

cbuffer PS_PIXELSIZE : register(b1) {
	float fPixelWidth;
	float fPixelHeight;
};

// PS_VARIABLES
float camX;
float camY;
float zoom;
float camTheta;
float camFOV;
float camDist;
float4 fogColor;
float fogAlpha;
int srcWidth;
int srcHeight;
int wrapMode;

// Produce an affine matrix for rotating a homogenous 2D vector.
float3x3 rotate(float theta) {
  float3x3 r = {
    cos(theta), -sin(theta), 0.0f, // row 1
    sin(theta), cos(theta), 0.0f, // row 2
    0.0f,        0.0f,       1.0f  // row 3
  };
  return r;
}

// Produce an affine matrix for scaling a homogeneous 2D vector.
float3x3 scale(float x, float y) {
  float3x3 r = {
    x,    0.0f, 0.0f, // row 1
    0.0f, y,    0.0f, // row 2
    0.0f, 0.0f, 1.0f  // ro2 3
  };
  return r;
}

// Produce an affine matrix for translating a homogeneous 2D vector.
float3x3 translate(float x, float y) {
  float3x3 r = {
    1.0f, 0.0f, x,   // row 1
    0.0f, 1.0f, y,   // row 2
    0.0f, 0.0f, 1.0f // ro2 3
  };
  return r;
}

PS_OUTPUT ps_main( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;

    float4 bgColor = tex2D(Tex0, In.Texture);
    float dstWidth = 1.0f / fPixelWidth;
    float dstHeight = 1.0f / fPixelHeight;

    // The order of transforms here is kinda weird. The main thing to keep in mind
    // here is that we're transforming our dst coordinates to src coordinates to
    // get the appropriate pixels from the src image.
    // So the order that we do things is sort of the reverse from what we'd do
    // in a vertex shader.
    float3 screen = float3(1.0f - In.Texture.x, camFOV * (1.0f - In.Texture.y), 1.0f);
    float3 uv = float3(screen.x, screen.y, 1.0f);

    uv = mul(translate(-0.5f, 0.0f), uv);
    uv = mul(scale(1.0f / (1.0f - screen.y), 1.0f / (1.0f - screen.y)), uv);
    uv = mul(scale(dstWidth / srcWidth, dstHeight / srcHeight), uv);
    uv = mul(scale(zoom, zoom), uv);
    uv = mul(translate(0.f, -camDist/srcHeight), uv);
    uv = mul(rotate((3.0f*PI/2.0f) - camTheta), uv);
    uv = mul(translate(camX/srcWidth, camY/srcHeight), uv);

    // Image wrapping
    bool oob = false;
    float2 uv2 = float2(uv.x % 1.0f, uv.y % 1.0f);
    if ((wrapMode & 0x01) == 0 && (uv.x < 0.0f || uv.x > 1.0f))
      oob = true;
    else if (uv2.x < 0.0f)
      uv2.x = 1.0f + uv2.x;

    if ((wrapMode & 0x02) == 0 && (uv.y < 0.0f || uv.y > 1.0f))
      oob = true;
    else if (uv2.y < 0.0f)
      uv2.y = 1.0f + uv2.y;

    // Get the pixel from the source image. If its alpha is 0, just use the
    // background graphic.
    float4 imgColor = tex2D(srcImage, uv2.xy);
    if (oob)
      imgColor.a = 0.0f;

    if (imgColor.a > 0.0f)
      Out.Color.rgba = imgColor;
    else
      Out.Color.rgba = bgColor;

    // Fog
    if (fogAlpha > 0.0) {
      float3 pixelXY = mul(scale(srcWidth, srcHeight), uv);
      float pixelDist = distance(float3(camX, camY, 1.0f), pixelXY);
      float alpha = min(1.0f, pixelDist / fogAlpha);
      alpha *= alpha;
      Out.Color.rgb = float3(
        alpha * fogColor.r + (1.0f - alpha) * Out.Color.r,
        alpha * fogColor.g + (1.0f - alpha) * Out.Color.g,
        alpha * fogColor.b + (1.0f - alpha) * Out.Color.b
      );
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
