
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


//shader_type canvas_item;
sampler2D SCREEN_TEXTURE : register(s1) = sampler_state {
MinFilter = Linear;
MagFilter = Linear;
};
float TIME;

uniform float screen_width;
uniform float screen_height;

// Curvature
uniform float BarrelPower;
// Color bleeding
uniform float color_bleeding;
uniform float bleeding_range_x;
uniform float bleeding_range_y;
// Scanline
uniform float lines_distance;
uniform float scan_size;
uniform float scanline_alpha;
uniform float lines_velocity;

float2 distort(float2 p) 
{
	float angle = p.y / p.x;
	float theta = atan2(p.y,p.x);
	float radius = pow(length(p), BarrelPower);
	
	p.x = radius * cos(theta);
	p.y = radius * sin(theta);
	
	return 0.5 * (p + float2(1.0,1.0));
}

void get_color_bleeding(inout float4 current_color,inout float4 color_left){
	current_color = current_color*float4(color_bleeding,0.5,1.0-color_bleeding,1);
	color_left = color_left*float4(1.0-color_bleeding,0.5,color_bleeding,1);
}

void get_color_scanline(float2 uv,inout float4 c,float time){
	float line_row = floor((uv.y * screen_height/scan_size) + fmod(time*lines_velocity, lines_distance));
	float n = 1.0 - ceil((fmod(line_row,lines_distance)/lines_distance));
	c = c - n*c*(1.0 - scanline_alpha);
	c.a = 1.0;
}

float4 fragment(float2 texCoord : TEXCOORD) : COLOR
{
	float2 xy = texCoord * 2.0;
	xy.x -= 1.0;
	xy.y -= 1.0;
	
	float d = length(xy);
	if(d < 1.5){
		xy = distort(xy);
	}
	else{
		xy = texCoord;
	}
	
	float pixel_size_x = 1.0/screen_width*bleeding_range_x;
	float pixel_size_y = 1.0/screen_height*bleeding_range_y;
	float4 color_left = tex2D(SCREEN_TEXTURE,xy - float2(pixel_size_x, pixel_size_y));
	float4 current_color = tex2D(SCREEN_TEXTURE,xy);
	get_color_bleeding(current_color,color_left);
	float4 c = current_color+color_left;
	get_color_scanline(xy,c,TIME);
	return c;

}


// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a fragment();
    }  
}