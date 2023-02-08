struct PS_INPUT {
float4 tint : COLOR0;
float2 texCoord : TEXCOORD0;
};

Texture2D<float4> RTTexture : register(t0);
sampler RT : register(s0);

cbuffer PS_VARIABLES : register(b0) {
float dist;
float offx;
float offy;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET {  
   
float sampleDist0 = dist;  
  
float2 samples[1] = {  
    offx, offy,  
};  
float2 samples2[1] = {  
   -offx, -offy,  
};  
float4 sum = RTTexture.Sample(RT, In.texCoord);  

float4 col1 = RTTexture.Sample(RT, In.texCoord + sampleDist0 * samples[0]);  
float4 col2 = RTTexture.Sample(RT, In.texCoord + sampleDist0 * samples2[0]);  
float4 red = {1,0,0,1};         
float4 blue = {0,1,1,1};  
sum += col1 * red;  
sum += col2 * blue;  
       
return sum / 2 * In.tint;     
  
}