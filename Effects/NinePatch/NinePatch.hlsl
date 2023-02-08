// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float xScale = 1.0;
	float yScale = 1.0;
}

cbuffer PS_PIXELSIZE:register(b1){
	float fPixelWidth; 
	float fPixelHeight; 
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float Width;
	float Height;
	float OrigWidth;
	float OrigHeight;

    float4 Color = Tex0.Sample(Tex0Sampler, float2(0.5,0.5) );
    OrigWidth = (1/fPixelWidth) / xScale;
    OrigHeight = (1/fPixelHeight) / yScale;
    float ChunkWidth = OrigWidth / 3.0;
    float ChunkHeight = OrigHeight / 3.0;
    Width = (1/fPixelWidth) ;
    Height = (1/fPixelHeight) ;

    float2 Pos; 
    Pos.x = In.texCoord.x * Width;
    Pos.y = In.texCoord.y * Height;

    float2 OrigPos; 
    OrigPos.x = In.texCoord.x * xScale;
    OrigPos.y = In.texCoord.y * yScale;


    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth && Pos.y < ChunkHeight  ) {   //Top
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2( (In.texCoord.x+1)/3, OrigPos.y));
    }

    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth && Pos.y > Height-ChunkHeight  ) {   //Bottom
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2( (In.texCoord.x+1)/3, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }

    if(Pos.x< ChunkWidth && Pos.y> ChunkHeight && Pos.y < Height-ChunkHeight  ) {   //Left

        Color = Tex0.Sample(Tex0Sampler,  float2( OrigPos.x,  (In.texCoord.y+1)/3    ));
    }

    if(Pos.y> ChunkHeight && Pos.x> Width-ChunkWidth && Pos.y < Height-ChunkHeight  ) {   //Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2((OrigWidth-ChunkWidth + Chunk.x)/Width * xScale, (In.texCoord.y+1)/3));
    }


    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth 
     && Pos.y > ChunkHeight && Pos.y < Height- ChunkHeight  ) {                           //Center
        Color = Tex0.Sample(Tex0Sampler, float2(  ((In.texCoord.x+1)/3), ((In.texCoord.y+1)/3)      ));
    }


//////////////////

    if(Pos.x < ChunkWidth  && Pos.y < ChunkHeight  ) {   //Upper Left
        Color = Tex0.Sample(Tex0Sampler, OrigPos.xy);
    }

    if(Pos.x> Width-ChunkWidth  && Pos.y < ChunkHeight  ) {   //Upper Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2((OrigWidth - ChunkWidth + Chunk.x)/Width * xScale, OrigPos.y));
    }

    if(Pos.x< ChunkWidth  && Pos.y > Width-ChunkHeight  ) {   //Lower Left
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2(OrigPos.x, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }


    if(Pos.x> Width-ChunkWidth  && Pos.y > Width-ChunkHeight  ) {   //Lower Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = Tex0.Sample(Tex0Sampler,  float2((OrigWidth - ChunkWidth + Chunk.x)/Width * xScale, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }
		Color *= In.Tint;
        return Color;
}



