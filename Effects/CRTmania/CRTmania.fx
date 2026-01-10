/* ======================
Based on cgwg's CRT shader
Copyright (C) 2010 cgwg
http://filthypants.blogspot.com/2010/12/crt-pixel-shader-filter-for-snes.html
====================== */

sampler2D rubyTexture;

bool useInput;
bool useOutput;

float inputW;
float inputH;
float outputW;
float outputH;

float fPixelWidth, fPixelHeight;

float2 rubyInputSize = 128;
float2 rubyOutputSize = 128;
float2 rubyTextureSize = 128;

// Abbreviations
//#define TEX2D(c) texture2D(rubyTexture, (c))
#define TEX2D(c) pow(tex2D(rubyTexture, (c)), inputGamma)        		
#define FIX(c)   max(abs(c), 1e-6);
#define PI 3.141592653589

// Adjusts the vertical position of scanlines. Useful if the output
// pixel size is large compared to the scanline width (so, scale
// factors less than 4x or so). Ranges from 0.0 to 1.0.
float phase = 0.0;

// Assume NTSC 2.2 Gamma for linear blending
float inputGamma = 2.2;

// Simulate a CRT gamma of 2.5
float outputGamma = 2.5;

// Controls the intensity of the barrel distortion used to emulate the
// curvature of a CRT. 0.0 is perfectly flat, 1.0 is annoyingly
// distorted, higher values are increasingly ridiculous.
float distortion = 0.1;

// Apply radial distortion to the given coordinate.
float2 radialDistortion(float2 coord)
{
	coord *= rubyTextureSize / rubyInputSize;
	float2 cc = coord - 0.5;
	float dist = dot(cc, cc) * distortion;				
	return (coord + cc * (1.0 + dist) * dist) * rubyInputSize / rubyTextureSize;
}

// Calculate the influence of a scanline on the current pixel.
//
// 'distance' is the distance in texture coordinates from the current
// pixel to the scanline in question.
// 'color' is the colour of the scanline at the horizontal location of
// the current pixel.
float4 scanlineWeights(float dist, float4 color)
{
	// The "width" of the scanline beam is set as 2*(1 + x^4) for
	// each RGB channel.
	float4 wid = 2.0 + 2.0 * pow(color, 4.0);
	
	// The "weights" lines basically specify the formula that gives
	// you the profile of the beam, i.e. the intensity as
	// a function of distance from the vertical center of the
	// scanline. In this case, it is gaussian if width=2, and
	// becomes nongaussian for larger widths. Ideally this should
	// be normalized so that the integral across the beam is
	// independent of its width. That is, for a narrower beam
	// "weights" should have a higher peak at the center of the
	// scanline than for a wider beam.
	float4 weights = dist * 3.333333;                
	return 0.51 * exp(-pow(weights * sqrt(2.0 / wid), wid)) / (0.18 + 0.06 * wid);
}

float4 ps_main( float2 texCoord  : TEXCOORD0 ) : COLOR
{
	// Here's a helpful diagram to keep in mind while trying to
	// understand the code:
	//
	//  |      |      |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//  |  01  |  11  |  21  |  31  | <-- current scanline
	//  |      | @    |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//  |  02  |  12  |  22  |  32  | <-- next scanline
	//  |      |      |      |      |
	// -------------------------------
	//  |      |      |      |      |
	//
	// Each character-cell represents a pixel on the output
	// surface, "@" represents the current pixel (always somewhere
	// in the bottom half of the current scan-line, or the top-half
	// of the next scanline). The grid of lines represents the
	// edges of the texels of the underlying texture.
	
	rubyTextureSize = 1.0 / float2(fPixelWidth,fPixelHeight);
	
	rubyInputSize = rubyTextureSize * float2(inputW,inputH);
	rubyOutputSize = rubyTextureSize * float2(outputW,outputH);
		
	// The size of one texel, in texture-coordinates.
	float2 one = 1.0 / rubyTextureSize;
	
	// Texture coordinates of the texel containing the active pixel				
	float2 xy = radialDistortion(texCoord);
	
	// Of all the pixels that are mapped onto the texel we are
	// currently rendering, which pixel are we currently rendering?
	float2 uv_ratio = frac(xy * rubyTextureSize) - 0.5;
	
	// Snap to the center of the underlying texel.                
	xy = (floor(xy * rubyTextureSize) + 0.5) / rubyTextureSize;
	
	// Calculate Lanczos scaling coefficients describing the effect
	// of various neighbour texels in a scanline on the current
	// pixel.				
	float4 coeffs = PI * float4(1.0 + uv_ratio.x, uv_ratio.x, 1.0 - uv_ratio.x, 2.0 - uv_ratio.x);                				
	
	// Prevent division by zero
	coeffs = FIX(coeffs);
	coeffs = 2.0 * sin(coeffs) * sin(coeffs / 2.0) / (coeffs * coeffs);
	
	// Normalize
	coeffs /= dot(coeffs, 1.0);
	
	// Calculate the effective colour of the current and next
	// scanlines at the horizontal location of the current pixel,
	// using the Lanczos coefficients above.								
	float4 col  = clamp(coeffs.x * TEX2D(xy + float2(-one.x, 0.0))   + coeffs.y * TEX2D(xy) + coeffs.z * TEX2D(xy + float2(one.x, 0.0)) + coeffs.w * TEX2D(xy + float2(2.0 * one.x, 0.0)),   0.0, 1.0);
	float4 col2 = clamp(coeffs.x * TEX2D(xy + float2(-one.x, one.y)) + coeffs.y * TEX2D(xy + float2(0.0, one.y)) + coeffs.z * TEX2D(xy + one)              + coeffs.w * TEX2D(xy + float2(2.0 * one.x, one.y)), 0.0, 1.0);
	
	// col  = pow(col, float4(inputGamma));    
	// col2 = pow(col2, float4(inputGamma));
	
	// Calculate the influence of the current and next scanlines on
	// the current pixel.
	float4 weights  = scanlineWeights(abs(uv_ratio.y) , col);
	float4 weights2 = scanlineWeights(1.0 - uv_ratio.y, col2);
	float3 mul_res  = (col * weights + col2 * weights2).xyz;
	
	// mod_factor is the x-coordinate of the current output pixel.
	float mod_factor = texCoord.x * rubyOutputSize.x * rubyTextureSize.x / rubyInputSize.x;
	
	// dot-mask emulation:
	// Output pixels are alternately tinted green and magenta.
	float3 dotMaskWeights = lerp(
      	float3(1.05, 0.75, 1.05),
      	float3(0.75, 1.05, 0.75),
      	floor(fmod(mod_factor, 2.0))
  	);
	
	mul_res *= dotMaskWeights;
	
	// Convert the image gamma for display on our output device.
	mul_res = pow(mul_res, 1.0 / (2.0 * inputGamma - outputGamma));
	
	return float4(mul_res, 1.0);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }