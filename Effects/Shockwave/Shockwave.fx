sampler2D img ;
sampler2D bkd : register(s1);
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

sampler2D Tex0;
float t_timer;
float pos_x;
float pos_y;
 
 
float4 ps_main(in float2 uv : TEXCOORD0 ) : COLOR0
{
             
              PS_OUTPUT Out;
           //   float4 color = tex2D(img,  uv+0.5);
           
           //Sawtooth function to pulse from centre.
            float offset = (t_timer- floor(t_timer))/t_timer;
            float CurrentTime = (t_timer*offset);    
            
            float3 WaveParams = float3(10.0, 0.8, 0.1 );
             
               
            float2 WaveCentre = float2(pos_x, pos_y);
          
            float Dist = distance(uv, WaveCentre);
            
            
            Out.Color = tex2D(Tex0, uv);
           
           
           if ((Dist <= ((CurrentTime) + (WaveParams.z))) && (Dist >= ((CurrentTime) - (WaveParams.z)))) 
    {
        //The pixel offset distance based on the input parameters
        float Diff = (Dist - CurrentTime); 
        float ScaleDiff = (1.0 - pow(abs(Diff * WaveParams.x), WaveParams.y)); 
        float DiffTime = (Diff  * ScaleDiff);
        
        //The direction of the distortion
        float2 DiffTexCoord = normalize(uv - WaveCentre);         
        
        //Perform the distortion and reduce the effect over time
        uv+= ((DiffTexCoord * DiffTime) / (CurrentTime * Dist * 40.0));
        Out.Color = tex2D(Tex0, uv);
        
        //Blow out the color and reduce the effect over time
        Out.Color += (Out.Color * ScaleDiff) / (CurrentTime * Dist * 40.0);
    } 
    
     

    return Out.Color;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}