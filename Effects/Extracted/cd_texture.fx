// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;
sampler2D img : register(s1); 
float offsetX;
float offsetY;
float sizeX;
float sizeY;
float alpha;
bool hidden;

// Blend coefficient

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 overlay = tex2D(img,In.Texture);
    Out.Color = tex2D(Tex0, In.Texture);
    
    // Backup Alpha
    float keepAlpha = Out.Color.a;

	overlay = tex2D(img, float2((In.Texture.x*sizeX)+offsetX,(In.Texture.y*sizeY)+offsetY));

    float4 join;
    
	if (alpha == 2) {
		float4 B = tex2D(Tex0,In.Texture);
		float keepAlphaOverlay = overlay.a;
		overlay = B<0.5?(2.0*B*overlay):(1.0-2.0*(1.0-B)*(1.0-overlay));
		overlay.a = keepAlphaOverlay;
	}
    
    join.r = ( overlay.r * overlay.a + Out.Color.r * Out.Color.a * (1.0 - overlay.a) );
    join.g = ( overlay.g * overlay.a + Out.Color.g * Out.Color.a * (1.0 - overlay.a) );
    join.b = ( overlay.b * overlay.a + Out.Color.b * Out.Color.a * (1.0 - overlay.a) );
    join.a = (overlay.a + Out.Color.a * ( 1.0 - overlay.a ));
    
    // texture opacity
    if (alpha < 1) {
		join.r = Out.Color.r * (1-alpha) + join.r * alpha;
		join.g = Out.Color.g * (1-alpha) + join.g * alpha;
		join.b = Out.Color.b * (1-alpha) + join.b * alpha;
	}
	
    Out.Color = join;
    
    // Restore Alpha
    if (hidden) {
		Out.Color = overlay;
		Out.Color.a = keepAlpha - (1-overlay.a);
    }
	else {
		Out.Color.a = keepAlpha;
	}
	
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}