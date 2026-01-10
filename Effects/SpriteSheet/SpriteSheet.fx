sampler2D img : register(s0);
sampler2D spriteSheetTex : register(s1) = sampler_state {MinFilter = linear; MagFilter = linear;};

int spriteSheetWidth;
int spriteSheetHeight;
int spriteWidth;
int spriteHeight;
float spriteColumns;
float spriteIndex;

	//int Col;

	//int TarRows;
	//int TarColumns;

float4 ps_main(float4 color : COLOR0, in float2 input : TEXCOORD0) : COLOR0	{

	float w = spriteSheetWidth;
	
	float h = spriteSheetHeight;
	
	// Normalize sprite size (0.0-1.0)
	float dx = spriteWidth / w;
	float dy = spriteHeight / h;

	//Figure out the number of tile cols of the sprite sheet.
	float cols = spriteColumns;


	//From linear index to row/col pair.
	float col = fmod((spriteIndex-1.0), cols);
	float row = floor((spriteIndex-1.0)/ cols);
	
	float2 uv = float2 (col * dx + dx * input.x, row * dy + dy * input.y);
	
		float4 maskTexture = tex2D(spriteSheetTex,uv);
		
		color.rgb = maskTexture.rgb;
		color.a = maskTexture.a;

	return color ;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
