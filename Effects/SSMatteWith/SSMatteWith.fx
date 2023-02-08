sampler2D img : register(s0);
sampler2D Msheet : register(s1);

int SI;
int SpW;
int SpH;
int ShW;
int ShH;

int Col;
int MI;
int CD;

int TarRows;
int TarColumns;

float4 ps_main(float4 color : COLOR0, in float2 input : TEXCOORD0) : COLOR0	{
	float2 MCoord = input;
	float4 Maintexture = tex2D(img,input);
	if (SI > Col){
		TarRows = ceil(1.0*SI / Col)-1;
		TarColumns = (SI % Col)-1;
		}else{
		 TarRows = 0;
		 TarColumns = (SI % Col)-1;
		}

	//MCoord.x = (input.x * (1.0*SpriteWidth/SheetWidth))+ (TarColumns*(1.0*SpriteWidth/SheetWidth)) ;
	MCoord.x = (input.x + TarColumns) * (1.0*SpW/ShW);
	MCoord.y = (input.y + TarRows) * (1.0*SpH/ShH);

	float4 Masktexture = tex2D(Msheet,MCoord);

	if(Masktexture.a != 0 && Maintexture.a != 0)
	{
	color.rgb = (Masktexture.rgb * Masktexture.a) + (Maintexture.rgb*(1-Masktexture.a));
	}else{
	color = Maintexture;
	}

	return color ;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
