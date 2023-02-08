sampler2D Tex0;

float xScale = 1.0;
float yScale = 1.0;
float fPixelWidth;
float fPixelHeight;

float4 MyShader(float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 Color = tex2D(Tex0, float2(0.5,0.5) );
    float OrigWidth = (1/fPixelWidth) / xScale;
    float OrigHeight = (1/fPixelHeight) / yScale;
    float ChunkWidth = OrigWidth / 3.0;
    float ChunkHeight = OrigHeight / 3.0;
    float Width = (1/fPixelWidth) ;
    float Height = (1/fPixelHeight) ;

    float2 Pos; 
    Pos.x = Tex.x * Width;
    Pos.y = Tex.y * Height;

    float2 OrigPos; 
    OrigPos.x = Tex.x * xScale;
    OrigPos.y = Tex.y * yScale;


    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth && Pos.y < ChunkHeight  ) {   //Top
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2( (Tex.x+1)/3, OrigPos.y));
    }

    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth && Pos.y > Height-ChunkHeight  ) {   //Bottom
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2( (Tex.x+1)/3, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }

    if(Pos.x< ChunkWidth && Pos.y> ChunkHeight && Pos.y < Height-ChunkHeight  ) {   //Left

        Color = tex2D(Tex0,  float2( OrigPos.x,  (Tex.y+1)/3    ));
    }

    if(Pos.y> ChunkHeight && Pos.x> Width-ChunkWidth && Pos.y < Height-ChunkHeight  ) {   //Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2((OrigWidth-ChunkWidth + Chunk.x)/Width * xScale, (Tex.y+1)/3));
    }


    if(Pos.x> ChunkWidth && Pos.x< Width-ChunkWidth 
     && Pos.y > ChunkHeight && Pos.y < Height- ChunkHeight  ) {                           //Center
        Color = tex2D(Tex0,float2(  ((Tex.x+1)/3), ((Tex.y+1)/3)      ));
    }


//////////////////

    if(Pos.x < ChunkWidth  && Pos.y < ChunkHeight  ) {   //Upper Left
        Color = tex2D(Tex0,OrigPos.xy);
    }

    if(Pos.x> Width-ChunkWidth  && Pos.y < ChunkHeight  ) {   //Upper Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2((OrigWidth - ChunkWidth + Chunk.x)/Width * xScale, OrigPos.y));
    }

    if(Pos.x< ChunkWidth  && Pos.y > Width-ChunkHeight  ) {   //Lower Left
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2(OrigPos.x, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }


    if(Pos.x> Width-ChunkWidth  && Pos.y > Width-ChunkHeight  ) {   //Lower Right
        float2 Chunk;
        Chunk.x = Pos.x - (Width-ChunkWidth);
        Chunk.y = Pos.y - (Height-ChunkHeight);
        Color = tex2D(Tex0,  float2((OrigWidth - ChunkWidth + Chunk.x)/Width * xScale, (OrigHeight-ChunkHeight + Chunk.y)/Height * yScale));
    }

        return Color;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_a MyShader();
    }

}
