sampler2D img : register(s0);

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0 
{    
    float2 TexelSize = { 1.0F/320.0F, 1.0F/240.0F };
    float2 oldPixel = { texCoord.x * 640.0F, texCoord.y * 480.0F }; 
    float2 pixelCo = ceil(oldPixel); 
    float2 pos = {pixelCo.x % 2,pixelCo.y % 2}; 
     
    // Invert left and right if we are right 
    float2 offset_x = { TexelSize.x, 0 }; 
    if (pos.x == 0) offset_x = -offset_x; 
 
    // Invert above and below if we are bottom 
    float2 offset_y = { 0, TexelSize.y }; 
    if (pos.y == 0) offset_y = -offset_y; 
 
    float4 L = tex2D(img,   texCoord-offset_x); 
    float4 R = tex2D(img,   texCoord+offset_x); 
    float4 A = tex2D(img,   texCoord-offset_y); 
    float4 B = tex2D(img,   texCoord+offset_y); 
 
    bool al = all(A == L); 
    bool ar = all(A == R); 
    bool bl = all(B == L); 
 
    half4 ret = tex2D(img, texCoord); 
    if (al && !ar && !bl) ret = L;   
         
    return ret;  
     
} 
 
 
 
technique T 
{ 
    pass P 
    { 
        PixelShader = compile ps_2_0 ps_main(); 
    } 
} 