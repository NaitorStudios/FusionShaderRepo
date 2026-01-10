// Voxel Model Shader
// v1
// By MuddyMole / Sketchy / Adam Hawker
// Want to donate? https://www.buymeacoffee.com/adamhawker

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> imgModel : register(t1);
sampler imgSampler : register(s1);

cbuffer PS_VARIABLES:register(b0)
{
	// Declare the parameters imported from CF2.5.
	int iL, iW, iH, iMinClip, iMaxClip;
	float fH, fV, fR, fD, fZ, fDx, fDy, fDz;
	float4 cD, cA;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

// Define a helper function to rotate any float3 vector about the X axis.
float3 rotateX(float3 vec, float ang) {
  return float3(vec.x, (vec.y * cos(ang)) - (vec.z * sin(ang)), (vec.y * sin(ang)) + (vec.z * cos(ang)));
}

// Define a helper function to rotate any float3 vector about the Y axis.
float3 rotateY(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) + (vec.z * sin(ang)), vec.y, (vec.z * cos(ang)) - (vec.x * sin(ang))); 
}

// Define a helper function to rotate any float3 vector about the Z axis. This isn't used here, but I'm including it in case anyone wants to implement it themselves.
float3 rotateZ(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) - (vec.y * sin(ang)), (vec.x * sin(ang)) + (vec.y * cos(ang)), vec.z);
}

// Define a helper function to get the 2D texture coordinates of a pixel in 3D space.
float2 getPixelXY(float3 vec) {
  vec = round(vec);
  float layerWidth = iW / iL; // in pixels
  float xPxA = ((layerWidth * 0.5) + vec.x); // component of x in pixels from x
  float midL = trunc(iL * 0.5);
  float xPxB = (trunc(vec.z + midL) * layerWidth); // component of x in pixels from z
  float xPx = xPxA + xPxB; // combined x in pixels
  float yPx = (iH * 0.5) + vec.y; // in pixels
  return float2(xPx / iW, yPx / iH);
}
//Line 60
float4 effect(PS_INPUT In, bool PM ) : SV_TARGET {
  // Convert the angles from degrees to radians.
	float dH = radians(fH);
	float dV = radians(fV);
	float dR = radians(fR);
  		
	// Create a point "p" in 3D space from the 2D position of the current pixel.
	float3 p = float3((In.texCoord.x - 0.5) / fPixelWidth / fZ, (In.texCoord.y - 0.5) / fPixelHeight / fZ, 0.0);
		
	// Create another point "c" representing the camera, placed infront of the texture (along the X axis).
	float3 c = float3(0.0, 0.0, 0.0 - fD);
		
	// Set the origin (where the camera is aimed) to the centre of the texture.
	float3 o = float3(0.5 / fPixelWidth, 0.5 / fPixelHeight, 0.0);
		
	// Rotate "p" on the Y-axis and then X-axis, and then make its position relative to the original coordinate system again.
	p = rotateZ(rotateX(rotateY(p, dH), dV), dR);// + o;
	
	// Repeat the exact same process for the camera "c".
	c = rotateZ(rotateX(rotateY(c, dH), dV), dR);// + o;
		
	// Trace a line from the camera "c" to the pixel "p".
        float3 l = normalize(p - c);

	// Clipping distances.
	float3 s = c + (l * iMinClip);
        int v = iMaxClip - iMinClip;
	float4 smpl = float4( 0.0, 0.0, 0.0, 0.0 );
	float4 outColor = float4( 0.0, 0.0, 0.0, 0.0);
	float3 norm = float3(0.0, 0.0, 0.0);

	// Build directional light vector from individual parameters.
	float3 dirLight = normalize(float3(fDx, fDy, fDz));
	// Trace a ray towards the model.
        for (int i=0; i<200; i++) {
		s += l; // s = current pixel
		v--;
		if (v <= 0 ) { break; } // stop once maximum view range exceeded.
		if ( s.x > 0.0 - ((iW / iL) * 0.5) && s.x < (iW / iL) * 0.5) {
		smpl = imgModel.SampleLevel(imgSampler, getPixelXY(s), 0); // Sample current pixel.
                if (smpl.a > 0.0) { // if current pixel is not empty.
			outColor = smpl;
			// Sample neighbouring pixels to calculate surface normal. These ones are optional but improve the appearance.
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x - 1.0, s.y, s.z)), 0).a == 0.0) { norm.x--; }
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x + 1.0, s.y, s.z)), 0).a == 0.0) { norm.x++; }
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x, s.y - 1.0, s.z)), 0).a == 0.0) { norm.y--; }
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x, s.y + 1.0, s.z)), 0).a == 0.0) { norm.y++; }
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x, s.y, s.z - 1.0)), 0).a == 0.0) { norm.z--; }
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x, s.y, s.z + 1.0)), 0).a == 0.0) { norm.z++; } 
			// These ones are required.
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x -1.0, s.y - 1.0, s.z - 1.0)), 0).a == 0.0) { norm.x--; norm.y--; norm.z--;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x -1.0, s.y - 1.0, s.z + 1.0)), 0).a == 0.0) { norm.x--; norm.y--; norm.z++;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x -1.0, s.y + 1.0, s.z - 1.0)), 0).a == 0.0) { norm.x--; norm.y++; norm.z--;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x +1.0, s.y - 1.0, s.z - 1.0)), 0).a == 0.0) { norm.x++; norm.y--; norm.z--;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x +1.0, s.y + 1.0, s.z + 1.0)), 0).a == 0.0) { norm.x++; norm.y++; norm.z++;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x +1.0, s.y + 1.0, s.z - 1.0)), 0).a == 0.0) { norm.x++; norm.y++; norm.z--;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x +1.0, s.y - 1.0, s.z + 1.0)), 0).a == 0.0) { norm.x++; norm.y--; norm.z++;}
			if (imgModel.SampleLevel(imgSampler, getPixelXY(float3(s.x -1.0, s.y + 1.0, s.z + 1.0)), 0).a == 0.0) { norm.x--; norm.y++; norm.z++;}
			// Rotate the surface normal to match the model's rotation.
			float3 u = rotateZ(rotateY(rotateX(norm, -1 * dV), -1 * dH), -1 * dR);
			// Calculate the combined directional and ambient light on the voxel.
			outColor.rgb *= ((max(0.0, dot(normalize(u), dirLight)) * cD.rgb) + cA.rgb) ;
			outColor.a = 1.0;
			break;
		}
		} 
	}
	if (PM) {outColor.rgb *= outColor.a;}
	return outColor;// * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}