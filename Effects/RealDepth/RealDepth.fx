sampler2D bkd : register(s1);
float fDepth;

//struct PS_INPUT
//{ float2 curr_pix: TEXCOORD0; };

struct PS_OUTPUT
{  float4 Color : COLOR0;
  float Depth : DEPTH; }; 

PS_OUTPUT ps_main( float2 In : TEXCOORD0 ) {
PS_OUTPUT outPix;

float4 colorOut = tex2D( bkd, In );
float4 depthOut = In.y;
if (fDepth > 0) { depthOut = fDepth; }
outPix.Color = colorOut;
outPix.Depth = depthOut;

return outPix;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}