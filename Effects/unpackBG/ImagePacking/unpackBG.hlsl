// Define textures and sampler
Texture2D<float4> t_img : register(t0); // object texture
Texture2D<float4> t_bkd : register(t1); // background texture
sampler s_img : register(s0);

// Import parameters from CF2.5 (parameters MUST be in the same order as in the xml file)
cbuffer PS_VARIABLES : register(b0) {
  int selectedImage;
}

// Define input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 curr_pix : TEXCOORD0; // coordinates of current pixel, within texture
};

// The main shader function (note that the function returns a float4 colour, not a structure)
float4 ps_main( in PS_INPUT In ) : SV_TARGET {

float4 pixel = t_bkd.Sample(s_img, In.curr_pix);
uint i = pixel[uint(selectedImage / 4.0)] * 255;
uint l = i >> (2 * uint(selectedImage % 4.0)) & 3u;
float4 Out_Color = float4( l/3.0, l/3.0, l/3.0, 1.0);
return Out_Color;

}