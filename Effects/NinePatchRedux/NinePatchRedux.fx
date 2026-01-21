sampler2D tex;

float xScale = 1.0;
float yScale = 1.0;
int repeat = 1;

const float ONETHIRD = 1.0/3.0;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float chunkWidth = 1.0 / (3.0 * xScale);
    float chunkHeight = 1.0 / (3.0 * yScale);

    float2 newCoord;

    if(repeat) {
        newCoord = float2(
            ONETHIRD * fmod(texCoord.x - chunkWidth, chunkWidth) / chunkWidth + ONETHIRD, 
            ONETHIRD * fmod(texCoord.y - chunkHeight, chunkHeight) / chunkHeight + ONETHIRD);
    } else {
        newCoord = float2(
            ONETHIRD * (texCoord.x - chunkWidth) / (1.0 - 2.0 * chunkWidth) + ONETHIRD,
            ONETHIRD * (texCoord.y - chunkHeight) / (1.0 - 2.0 * chunkHeight) + ONETHIRD);
    }

    if(texCoord.x < chunkWidth) {
        newCoord.x = ONETHIRD * texCoord.x / chunkWidth;
    }
    if(texCoord.x > 1.0 - chunkWidth) {
        newCoord.x = ONETHIRD*(2.0 + (texCoord.x - 1.0 + chunkWidth) / chunkWidth);
    }
    if(texCoord.y < chunkHeight) {
        newCoord.y = ONETHIRD * texCoord.y / chunkHeight;
    }
    if(texCoord.y > 1.0 - chunkHeight) {
        newCoord.y = ONETHIRD*(2.0 + (texCoord.y - 1.0 + chunkHeight) / chunkHeight);
    }
    float4 color = tex2D(tex, newCoord);
    return color;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 ps_main();
    }
}
