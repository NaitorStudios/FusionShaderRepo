sampler RT: register(s0);  
float dist;
float offx;
float offy;

float4 PixelShader(float2 texCoord: TEXCOORD0) : COLOR {  
   
float sampleDist0 = dist;  
  
float2 samples[1] = {  
    offx, offy,  
};  
float2 samples2[1] = {  
   -offx, -offy,  
};  
float4 sum = tex2D(RT, texCoord);  
   for (int i = 0; i < 1; i++){  

float4 col1 = tex2D(RT, texCoord + sampleDist0 * samples[i]);  
float4 col2 = tex2D(RT, texCoord + sampleDist0 * samples2[i]);  
float4 red = {1,0,0,1};         
float4 blue = {0,1,1,1};  
sum += col1 * red;  
sum += col2 * blue;  
}  
       
return sum / 2;     
  
}  
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 PixelShader(); }}