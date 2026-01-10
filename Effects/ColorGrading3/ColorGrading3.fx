sampler2D bkd : register(s1);
uniform sampler2D lut;
uniform float lutSize = 17.0;

// Gets interpolation percentage for color channel using floor and diff values.
float get_interp_percent_channel(float channel_value, float floor_value, float diff_value){
	// Workaround to avoid division by zero and return zero
	float div_sign = abs(sign(diff_value));
	return (channel_value-floor_value)*div_sign/(diff_value + (div_sign-1.0));
}

// Gets interpolation percentage for color using floor and diff values.
float3 get_interp_percent_color(float3 color, float3 floorc, float3 diff){
	float3 res = 0.0;
	res.r = get_interp_percent_channel(color.r, floorc.r, diff.r);
	res.g = get_interp_percent_channel(color.g, floorc.g, diff.g);
	res.b = get_interp_percent_channel(color.b, floorc.b, diff.b);
	return res;
}

// Get interpolated color using color floor, diff and channel percentage.
float3 get_interpolated_color(float3 floorc, float3 diff, float perc){
	return floorc.rgb + diff.rgb * perc;
}

// Applies gamma correction to convert color from linear space to sRGB.
float3 convert_linear_to_srgb(float3 linear_color){
	float gamma = 2.2;
	return pow(linear_color.rgb, 1.0/gamma);
}

// Gets LUT mapped color using trilinear interpolation.
float4 get_lut_mapping_trilinear(float4 old_color){
	float lut_div = lutSize - 1.0;
	// Get floor and ceil colors and diff from identity lut
	float3 old_color_lut_base = lut_div * old_color.rgb;
	float3 old_color_floor_vec = floor(old_color_lut_base);
	float3 old_color_ceil_vec = ceil(old_color_lut_base);
	float3 old_color_diff = (old_color_floor_vec - old_color_ceil_vec)/lut_div;
	float3 old_color_percentages = get_interp_percent_color(old_color.rgb, old_color_floor_vec/lut_div, old_color_diff);
	// Get the surrounding 8 samples positions
	float3 lut_color_fff_vec = float3(old_color_floor_vec.r, old_color_floor_vec.g, old_color_floor_vec.b);
	float3 lut_color_ffc_vec = float3(old_color_floor_vec.r, old_color_floor_vec.g, old_color_ceil_vec.b);
	float3 lut_color_fcf_vec = float3(old_color_floor_vec.r, old_color_ceil_vec.g, old_color_floor_vec.b);
	float3 lut_color_fcc_vec = float3(old_color_floor_vec.r, old_color_ceil_vec.g, old_color_ceil_vec.b);
	float3 lut_color_cff_vec = float3(old_color_ceil_vec.r, old_color_floor_vec.g, old_color_floor_vec.b);
	float3 lut_color_cfc_vec = float3(old_color_ceil_vec.r, old_color_floor_vec.g, old_color_ceil_vec.b);
	float3 lut_color_ccf_vec = float3(old_color_ceil_vec.r, old_color_ceil_vec.g, old_color_floor_vec.b);
	float3 lut_color_ccc_vec = float3(old_color_ceil_vec.r, old_color_ceil_vec.g, old_color_ceil_vec.b);
	int2 lut_color_fff_pos = int2(int(lutSize*lut_color_fff_vec.b + lut_color_fff_vec.r), int(lut_color_fff_vec.g));
	int2 lut_color_ffc_pos = int2(int(lutSize*lut_color_ffc_vec.b + lut_color_ffc_vec.r), int(lut_color_ffc_vec.g));
	int2 lut_color_fcf_pos = int2(int(lutSize*lut_color_fcf_vec.b + lut_color_fcf_vec.r), int(lut_color_fcf_vec.g));
	int2 lut_color_fcc_pos = int2(int(lutSize*lut_color_fcc_vec.b + lut_color_fcc_vec.r), int(lut_color_fcc_vec.g));
	int2 lut_color_cff_pos = int2(int(lutSize*lut_color_cff_vec.b + lut_color_cff_vec.r), int(lut_color_cff_vec.g));
	int2 lut_color_cfc_pos = int2(int(lutSize*lut_color_cfc_vec.b + lut_color_cfc_vec.r), int(lut_color_cfc_vec.g));
	int2 lut_color_ccf_pos = int2(int(lutSize*lut_color_ccf_vec.b + lut_color_ccf_vec.r), int(lut_color_ccf_vec.g));
	int2 lut_color_ccc_pos = int2(int(lutSize*lut_color_ccc_vec.b + lut_color_ccc_vec.r), int(lut_color_ccc_vec.g));
	// Get gamma corrected color from LUT.
	float3 lut_color_fff = convert_linear_to_srgb(Texture 2D(lut, lut_color_fff_pos, 0).rgb);
	float3 lut_color_ffc = convert_linear_to_srgb(Texture 2D(lut, lut_color_ffc_pos, 0).rgb);
	float3 lut_color_fcf = convert_linear_to_srgb(Texture 2D(lut, lut_color_fcf_pos, 0).rgb);
	float3 lut_color_fcc = convert_linear_to_srgb(Texture 2D(lut, lut_color_fcc_pos, 0).rgb);
	float3 lut_color_cff = convert_linear_to_srgb(Texture 2D(lut, lut_color_cff_pos, 0).rgb);
	float3 lut_color_cfc = convert_linear_to_srgb(Texture 2D(lut, lut_color_cfc_pos, 0).rgb);
	float3 lut_color_ccf = convert_linear_to_srgb(Texture 2D(lut, lut_color_ccf_pos, 0).rgb);
	float3 lut_color_ccc = convert_linear_to_srgb(Texture 2D(lut, lut_color_ccc_pos, 0).rgb);
	// Calculate first level interpolations.
	float3 lut_color_iff = get_interpolated_color(lut_color_fff, lut_color_fff - lut_color_cff , old_color_percentages.r);
	float3 lut_color_ifc = get_interpolated_color(lut_color_ffc, lut_color_ffc - lut_color_cfc, old_color_percentages.r);
	float3 lut_color_icf = get_interpolated_color(lut_color_fcf, lut_color_fcf - lut_color_ccf, old_color_percentages.r);
	float3 lut_color_icc = get_interpolated_color(lut_color_fcc, lut_color_fcc - lut_color_ccc, old_color_percentages.r);
	// Calculate second level interpolations.
	float3 lut_color_iif = get_interpolated_color(lut_color_iff, lut_color_iff - lut_color_icf, old_color_percentages.g);
	float3 lut_color_iic = get_interpolated_color(lut_color_ifc, lut_color_ifc - lut_color_icc, old_color_percentages.g);
	// Calculate third and final interpolation.
	float3 lut_color_iii = get_interpolated_color(lut_color_iif, lut_color_iif - lut_color_iic, old_color_percentages.b);
	// Get final color with original alpha.
	float4 final_color = float4(lut_color_iii, old_color.a);
	return final_color;
}


float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {
	float4 color = texture(bkd,In);
	color = get_lut_mapping_trilinear(color);
	COLOR = color;
}


technique tech_main {
    pass P0 {
        PixelShader = compile ps_2_a ps_main();
    }
}