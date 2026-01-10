// Updated Shader.fx
sampler2D img : register(s1);

float time;
float fPixelWidth, fPixelHeight;

float4 main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float offset = (time - floor(time)) / time;
    float CurrentTime = time * offset;
    float3 WaveParams = float3(10.0, 0.8, 0.1);
    float ratio = fPixelHeight / fPixelWidth;
    float2 WaveCentre = float2(0.5, 0.5 * ratio);
    texCoord.y *= ratio;
    float Dist = distance(texCoord, WaveCentre);
    float4 Color = tex2D(img, texCoord);

    if ((Dist <= ((CurrentTime) + (WaveParams.z))) && 
        (Dist >= ((CurrentTime) - (WaveParams.z))))
    {
        float Diff = (Dist - CurrentTime); 
        float ScaleDiff = (1.0 - pow(abs(Diff * WaveParams.x), WaveParams.y)); 
        float DiffTime = (Diff * ScaleDiff);
        float2 DiffTexCoord = normalize(texCoord - WaveCentre);         
        texCoord += ((DiffTexCoord * DiffTime) / (CurrentTime * Dist * 40.0));
        Color = tex2D(img, texCoord);
        Color += (Color * ScaleDiff) / (CurrentTime * Dist * 40.0);
    } 
    
    return Color; 
}

technique Tech1
{
    pass P0
    {
        PixelShader = compile ps_2_0 main();
    }
}
