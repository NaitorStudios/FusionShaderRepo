//By Sebastian Janisz (Ultimate Walrus)
//Special thanks to Salamanderpants

// Global variables
sampler2D Tex0 = sampler_state
{
  MinFilter = Point;  //don't interpolate between pixel colors
  MagFilter = Point;
};

sampler2D bkd : register(s1); 


//Subpixel offset parameters
float fSubPixelOffsetX;
float fSubPixelOffsetY;


//These are PROVIDED by MMF.  Width and height of an individual pixel
float fPixelWidth;
float fPixelHeight;

//With those we pre-calculate this
float2 PixelSize;

//Other values hidden from MMF; these values are global (and thus uniform) for efficiency
float2 SubPixelOffset;



//See http://scale2x.sourceforge.net/algorithm.html for more info on the algorithm used.
//I did not use this exact algorithm because it is slow as a shader.
//I made a new algorithm that uses less branching but accomplishes the same result.

// SEB'S SCALE3X MODIFIED ALGORITHM
// Consider the following layout:
// 
//   000
//   0P0
//   000
//
// Where P is the currently sampled pixel (TexCoord/2), and 0 are adjacent source pixels.
// We're trying to expand P into a nine-pixel area like this:
//
//	 0-] 0-] 0-]
//   [-] [-] [-]
//   [-] [-] [-]
//
//   0-] PPP 0-]
//   [-] PPP [-]
//   [-] PPP [-]
//
//   0-] 0-] 0-]
//   [-] [-] [-]
//   [-] [-] [-]
//
// But, in a shader, we only do one pixel at a time.
// All we know is that we're one of these P's.
// Using frac(), we can determine the function of the adjacent pixels.
// While Scale2x was simple enough that all pixels function the same,
// Scale3x is a little more complex.  Therefore we will use an array of
// constant structs that dictate the rotation of adjacent pixels for each
// of the nine sub-pixels.

//There are three types of sub-pixels: corners, sides, and the center.
//Each has a different logic to how it decides whether to sample from an
//adjacent pixel, or the one it originally rested in.


//We a rotation matrix, which tells us how to rotate offsets A through I such that
//we can branch using the logic for E0 or E1 in the scale3x algorithm.

//Rather than store the matrices, we provides precalculated sine/cosine values for
//the rotation matrix that will rotate the offsets for the given subpixel.
//This is faster than simply storing the matrices, since memory
//lookups ar very expensive (but not as expensive as figuring
//out these sine/cosine values on the fly)
//We initialize this here to ensure it's only done once (not for every pixel, which would slow down
//the shader tremendously)
float2 SubpixelSinCos[3][3] =
{
	{
			float2( 1, 0), //[0][0] UL corner 
			float2( 0,-1), //[0][1] L side
			float2( 0,-1), //[0][2] DL corner
	},

	{
			float2( 1, 0), //[1][0] U side 
			float2( 0, 0), //[1][1] middle
			float2(-1, 0), //[1][2] D side
	},

	{
			float2( 0, 1),  //[2][0] UR corner
			float2(	0, 1),  //[2][1] R side
			float2(-1, 0),  //[2][2] DR corner
	}
};



//If the pixel is here(E0):
//
//     P*P
//     PPP
//     PPP
//
//
//Or here (E1):
//
//     *PP
//     PPP
//     PPP
//
//Then the offsets are ALWAYS as follows:
//
//	 [-] [-] [-]
//   [A] [B] [C]
//   [-] [-] [-]
//
//   [-] **P [-]
//   [D] PPP [F]
//   [-] PPP [-]
//
//	 [-] [-] o3]
//   [G] [H] [I]
//   [-] [-] [-]
//
//   If the algorithm returns positive


//If pixel is, for example, here:
//     PP*
//     PPP
//     PPP
//Then we use the constant rotation matrix to rotate the offsets to this pixel.  In
//this case, we'd want the matrix:
//       0 -1
//       1  0
//Which would give us:
//
//	 [-] [-] [-]
//   [G] [D] [A]
//   [-] [-] [-]
//
//   [-] PP* [-]
//   [H] PPP [B]
//   [-] PPP [-]
//
//	 [-] [-] [-]
//   [I] [F] [C]
//   [-] [-] [-]





float4 ps_main( float4 TexCoord : TEXCOORD0 ) : COLOR0
{
	//Precalculated uniform variables
	PixelSize = float2(fPixelWidth, fPixelHeight);
	SubPixelOffset = float2(fSubPixelOffsetX * fPixelWidth, fSubPixelOffsetY * fPixelHeight);
	

	//Per-pixel calculations
	float4 Out;  //eventual return value

	//Take subpixel offset into account.
	float2 realcoord = TexCoord.xy - SubPixelOffset;

	//Our pixels screen coordinate in pixels (as opposed to UV)
	//Ends in 0.5 due to the floating-point division.
	float2 pixelcoord = realcoord / PixelSize;

	//sample from a position in the upper left third
	float2 samplecoord = realcoord/3;

	float2 pfrac = frac( pixelcoord / 3 );  //gives us 0.16, 0.5, or 0.83
	pfrac *= 3;  //now we should have 0.5, 1.5, or 2.5 (the int cast then gives us a nice correlation into the array indices)

	int2 pint = pfrac;



	//Derive our rotation matrix based on the stored cosine/sine values at the corresponding subpixel index.
	float2 cossin = SubpixelSinCos[pint.x][pint.y];
	
	float2x2 rot = float2x2(	cossin.x, -cossin.y,
								cossin.y,  cossin.x);


	// A B C
	// D E F
	// G H I
	// Rotate these offsets if necessary with rot.
	float4 A = tex2D(bkd, samplecoord + mul(rot, float2(-1,-1))*PixelSize );
	float4 B = tex2D(bkd, samplecoord + mul(rot, float2( 0,-1))*PixelSize );
	float4 C = tex2D(bkd, samplecoord + mul(rot, float2( 1,-1))*PixelSize );

	float4 D = tex2D(bkd, samplecoord + mul(rot, float2(-1, 0))*PixelSize);
	float4 E = tex2D(bkd, samplecoord);  //in the original Scale3X algorithm, "E" denotes the center pixel which we are expanding
	float4 F = tex2D(bkd, samplecoord + mul(rot, float2( 1, 0))*PixelSize);

	//G unused
	float4 H = tex2D(bkd, samplecoord + mul(rot, float2( 0, 1))*PixelSize );
	//I unused




	//Calculate "subpixel type" at runtime.
	//This saves us some constant registers/memory lookups.
	// 0 = corner
	// 1 = side
	// 2 = middle
	int subpixel_type = 2 - (abs(pint.x-1) + abs(pint.y-1));


	//E0 = D == B && B != F && D != H ? D : E;
	//E1 = (D == B && B != F && D != H && E != C) || (B == F && B != D && F != H && E != A) ? B : E;
	//E4 = E
	//everything else is just rotated from E0 and E1


	//Logically simplified version of the scale2x algorithm.
	if(
		subpixel_type!=2 && (
			( (subpixel_type==0 || any(E!=C)) && all(D==B) && any(B!=F) && any(D!=H) ) ||
			( subpixel_type==1 && (all(B==F) && any(B!=D) && any(F!=H) && any(E!=A)) ) 
		)
	)
		Out = B;
	else
		Out = E;
	
	return Out;
}


// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    } 
}