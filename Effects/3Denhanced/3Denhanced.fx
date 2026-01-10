sampler2D img = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
    AddressU = Border;
    AddressV = Border;
    BorderColor = float4(0, 0, 0, 0);
};

float h1, h2, c1, c2, l1, l2;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
    // Get the Y coordinates of the four corners.
    float Ay = c1 - (h1 / 2);
    float By = c2 - (h2 / 2);
    float Cy = c2 + (h2 / 2);
    float Dy = c1 + (h1 / 2);

    // Find the intersection of the two diagonals.
    float Ix = (Dy - Ay) / ((Cy - Ay) - (By - Dy));
    float Iy = (Cy - Ay) * Ix + Ay;

    // Scale the Y coordinate based on the X coordinate.
    float ch = (h1 + (h2 - h1) * In.x) / 2;
    float cc = c1 + (c2 - c1) * In.x;
    float ty = (In.y - cc + ch) / (ch * 2);

    // Use cross-ratio metrology to correct the X coordinate.
    float cr = (In.x / (Ix - In.x)) / (1 / (Ix - 1));
    float tx = cr / (2 * cr - 1);

    // Sample the texture.
    float4 outRGBA = tex2D(img, float2(tx, ty));
    outRGBA.rgb *= l1 + (l2 - l1) * tx;
    return outRGBA;
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}