// ---------- Resources ----------
Texture2D<float4>	imgHeightmap   : register(t1);
Texture2D<float4>	imgTexturemap  : register(t2);
Texture2D<float4>	imgSky         : register(t3);

sampler				sampHeightmap  : register(s1);
sampler				sampTexturemap : register(s2);
sampler				sampSky        : register(s3);

// ---------- Constants ----------
cbuffer PS_VARIABLES : register(b0)
{
    float fX, fY, fZ;
    float fPan;
    float fCosPan, fSinPan;
    float fCosTilt, fSinTilt;
    float fYScale;
    float4 cFog;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

// ---------- I/O ----------
struct PS_INPUT
{
    float2 uv : TEXCOORD0;    // same as 'In' in the original
};

struct PS_OUTPUT
{
    float4 Color : SV_Target;
    float  Depth : SV_Depth;
};

// ---------- Shader ----------
PS_OUTPUT ps_main(PS_INPUT In)
{
    PS_OUTPUT outPixel;
    float4 outColor = float4(0, 0, 0, 0);

    // Build and orient the ray direction from screen uv
    float3 p = float3( (In.uv.x - 0.5), (0.5 - In.uv.y) * (fPixelWidth / fPixelHeight), 0.5);

    // Tilt (pitch) rotation
    p = float3( p.x,
                p.y * fCosTilt + p.z * fSinTilt,
                p.y * fSinTilt - p.z * fCosTilt );

    // Pan (yaw) rotation and normalize
    p = normalize( float3( p.x * fCosPan - p.z * fSinPan,
                           p.y,
                           p.x * fSinPan + p.z * fCosPan ) );

    float3 _step = p * 0.003;            // ray length factor
    float3 origin = float3(fX, fY, fZ);
    float3 ray = origin + _step * 68.0;  // start a bit out along the ray

    // March until we hit heightmap or run out of steps
    [loop]
    for (int i = 0; i < 67; ++i)
    {
        if (_step.x < 10000.0)
        {
            ray += _step;
        }

        // Sample height (R) and compare against current ray height
        float h = imgHeightmap.Sample(sampHeightmap, ray.xz).r * fYScale;
        if (h > ray.y)
        {
            // sentinel to stop advancing
            _step.x = 10000.0;
        }
    }

    // If we "hit", color from texture map; else, use sky
    if (_step.x >= 10000.0)
    {
        outColor = imgTexturemap.Sample(sampTexturemap, ray.xz);
    }

    // Depth: normalized distance along the ray (keep original scale, clamp to [0,1])
    float dist = length(ray - origin);
    outPixel.Depth = saturate(dist / 0.003 / 136.0);

    if (outColor.a > 0.0)
    {
        // Simple fog toward cFog.rgb as depth increases beyond 0.5
        float t = (outPixel.Depth - 0.5) * 2.0;
        outPixel.Color.rgb = lerp(outColor.rgb, cFog.rgb, t);
        outPixel.Color.a   = 1.0;
    }
    else
    {
        // Sky lookup (same mapping as original)
        float2 skyUV = float2( (In.uv.x + (fPan / 90.0)) * 0.25, In.uv.y * 2.0 );
        outPixel.Color = imgSky.Sample(sampSky, skyUV);
        outPixel.Color.a = 1.0;
    }

    return outPixel;
}
