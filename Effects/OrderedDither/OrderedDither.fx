sampler2D bkd : register(s1); 
sampler2D pattern : register(s2);

float imgWidth;
float imgHeight;
float2 offset;
float2 pick;

float4 ps_dither(in float2 texCoord : TEXCOORD0) : COLOR0	{
float4 inColor = tex2D( bkd, texCoord );
float oldLight = (0.3*inColor.r) + (0.6*inColor.g) + (0.1*inColor.b);
float newLight = int(oldLight * 25) / 25.0;

// Calculate offset of pixel within tile
offset.x = ((texCoord.x * imgWidth) % 4.0) / 4.0;
offset.y = ((texCoord.y * imgHeight) % 4.0) / 4.0;
pick.x = newLight + (offset.x / 25.0);
pick.y = offset.y;

float4 outColor = tex2D( pattern, pick );
//float4 outColor = float4( offset.x,offset.y,1,1);
//float4 outColor = float4(newLight,newLight,newLight,1);
return outColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_dither(); }  }