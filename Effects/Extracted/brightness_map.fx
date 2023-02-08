sampler2D img : register(s0);
sampler2D b_map : register(s1);

float X_pos, Y_pos;
float o_width, o_height;
float map_width, map_height;

float4 ps_main(in float2 this_pixel: TEXCOORD0) : COLOR0 {

float2 world_coords= float2(X_pos+ this_pixel.x*o_width,Y_pos+this_pixel.y*o_height);
float2 world_size= float2(map_width,map_height);

float brt= tex2D(b_map,world_coords/world_size).r;  // <--- you can change ".r" to any other color channel you might want to use
float4 Out= tex2D(img,this_pixel);
Out.rgb*=brt;

return Out;

}

technique tech_main { pass P0 {PixelShader = compile ps_2_0 ps_main(); }  }