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
//Assuming the following pixel layout:
// A B C
// D E F
// G H I
//
//We want to expand pixel "E" into:
// E0 E1
// E2 E3
//
//We can use the following to get the values:
//if (B != H && D != F) {
//	E0 = D == B ? D : E;
//	E1 = B == F ? F : E;
//	E2 = D == H ? D : E;
//	E3 = H == F ? F : E;
//} else {
//	E0 = E;
//	E1 = E;
//	E2 = E;
//	E3 = E;
//}
//
//----------------------------------------------------------------------------------
//However, this involves too much branching and so is slow as a shader.
//By understanding the logic of scale2x, we can come up with a new algorithm (sorta)
//that accomplishes the same thing more quickly in a shader.
//
// SEB'S SCALE2X MODIFIED ALGORITHM
// Consider the following layout:
// 
//    0
//   0P0
//    0
//
// Where P is the currently sampled pixel (TexCoord/2), and 0 are adjacent source pixels.
// We're trying to expand P into a four-pixel area like this:
//
//		0]
//      []
//
//   0] PP 0]
//   [] PP []
//
//      0]
//      []
//
// But, in a shader, we only do one pixel at a time.
// All we know is that we're one of these P's.
// But using frac(), we can determine the function of the adjacent pixels.
// Let's assume we're the lower right pixel:
//
//		0]
//      []
//
//   0] PP 0]
//   [] P* []
//
//      0]
//      []
//
// Now, get the two closest adjacent sample pixels (using frac) and label them cornerA and cornerB.
//
//		0]
//      []
//
//   0] PP CB
//   [] P* []
//
//      CA
//      []
//
//  Get the pixels on the opposite side and label them oppositeA and oppositeB.
//
//		0A
//      []
//
//   0B PP CB
//   [] P* []
//
//      CA
//      []
//
//  At this point, Scale2x can be simplified down to one simple branch:
//
//	if( CA==CB                 //the two corner pixels are the same
//		&& CA!=OA && CB!=OB )  //the pixels opposite the corners are different from them
//		Out = cornerA;    //color this pixel the same as the same-colored corners
//	else
//		Out = tex2D(Tex0, samplecoord);   //keep original color from smapling position






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
	//Ends in 0.25 or 0.75 due to the floating-point division.
	float2 pixelcoord = realcoord / PixelSize;

	//sample from a position in the upper left quadrant
	float2 samplecoord = realcoord/2;

	float2 pfrac = frac( pixelcoord / 2 );  //gives us 0.25 or 0.75 depending on even/odd
	pfrac = pfrac*4 - (float2)2;  //now we have -1 or 1

	//offset to get to the adjacent pixel off the "corner" of the expanded pixel.
	//so, in this example, adding corner_offset to samplecoord would give us OF:
	//		0A
	//      []
	//
	//   0B PP CB
	//   [] P* []
	//
	//      CA OF
	//      [] []
	float2 corner_offset = pfrac * PixelSize;

	//retrieve corner colors
	float4 cornerA = tex2D(bkd, samplecoord + float2(corner_offset.x,0));
	float4 cornerB = tex2D(bkd, samplecoord + float2(0,corner_offset.y));

	//retrieve opposite colors
	float4 oppositeA = tex2D(bkd, samplecoord - float2(corner_offset.x,0));
	float4 oppositeB = tex2D(bkd, samplecoord - float2(0,corner_offset.y));

	
	//If the corner colors are the same, but both different from their opposite sides,
	//  use the corner color.
	//else,
	//  use the original color.

	if( all( cornerA==cornerB ) && any( cornerA!=oppositeA ) && any( cornerB!=oppositeB ) )
		Out = cornerA;
	else
		Out = tex2D(bkd, samplecoord);

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