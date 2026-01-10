/*** MIT LICENSE
Copyright (c) 2022 torcado

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
***/ 

sampler2D img = sampler_state {
	AddressU = border;
	AddressV = border;
	BorderColor = float4(1.0,1.0,1.0,0.0);
};
float fPixelWidth, fPixelHeight;
//the color with the highest priority.
// other colors will be tested based on distance to this
// color to determine which colors take priority for overlaps.
float4 highestColor;
//how close two colors should be to be considered "similar".
// can group shapes of visually similar colors, but creates
// some artifacting and should be kept as low as possible.
float similarThreshold;
float lineWidth;

const float scale = 4.0;
const float3x3 yuv_matrix = float3x3(float3(0.299, 0.587, 0.114),
									 float3(-0.169, -0.331, 0.5),
									 float3(0.5, -0.419, -0.081));

float3 yuv(float3 col){
	return mul(yuv_matrix, col);
}

bool similar(float4 col1, float4 col2){
	return (col1.a == 0.0 && col2.a == 0.0) || distance(col1, col2) <= similarThreshold;
}

//multiple versions because Fusion doesn't support function overloading
//note: inner check should ideally check between all permutations
//  but this is good enough, and faster
bool similar3(float4 col1, float4 col2, float4 col3){
	return similar(col1, col2) && similar(col2, col3);
}

bool similar4(float4 col1, float4 col2, float4 col3, float4 col4){
	return similar(col1, col2) && similar(col2, col3) && similar(col3, col4);
}

bool similar5(float4 col1, float4 col2, float4 col3, float4 col4, float4 col5){
	return similar(col1, col2) && similar(col2, col3) && similar(col3, col4) && similar(col4, col5);
}

bool higher(float4 thisCol, float4 otherCol){
	bool output = false;
	if(similar(thisCol, otherCol)) output = false;
	if(thisCol.a == otherCol.a){
		output = distance(thisCol.rgb, highestColor.rgb) < distance(otherCol.rgb, highestColor.rgb);
	} else {
		output = thisCol.a > otherCol.a;
	}
	return output;
}

float distToLine(float2 testPt, float2 pt1, float2 pt2, float2 dir){
	float2 lineDir = pt2 - pt1;
	float2 perpDir = float2(lineDir.y, -lineDir.x);
	float2 dirToPt1 = pt1 - testPt;
	return (dot(perpDir, dir) > 0.0 ? 1.0 : -1.0) * (dot(normalize(perpDir), dirToPt1));
}

float4 sliceDist(float2 point, float2 mainDir, float2 pointDir, float4 u, float4 uf, float4 uff, float4 b, float4 c, float4 f, float4 ff, float4 db, float4 d, float4 df, float4 dff, float4 ddb, float4 dd, float4 ddf){
	float minWidth = 0.0;
	float maxWidth = 1.4;
	float _lineWidth = max(minWidth, min(maxWidth, lineWidth));
	point = mainDir * (point - 0.5) + 0.5;

	float distAgainst = 4.0*distance(f,d) + distance(uf,c) + distance(c,db) + distance(ff,df) + distance(df,dd);
	float distTowards = 4.0*distance(c,df) + distance(u,f) + distance(f,dff) + distance(b,d) + distance(d,ddf);
	bool shouldSlice = (distAgainst < distTowards) || (distAgainst < distTowards + 0.001) && !higher(c, f);

	if(similar4(f, d, b, u) && similar3(uf, df, db) && !similar(c, f)){
		shouldSlice = false;
	}
	if(!shouldSlice) return -1.0;

	float dist = 1.0;
	bool flip = false;
	float2 center = float2(0.5, 0.5);

	if(similar(f, d)) {
		if(similar(c, df) && higher(c, f)){
			if(!similar(c, dd) && !similar(c, ff)){
				flip = true; 
			}
		} else {
			if(higher(c, f)){
				flip = true; 
			}
			if(!similar(c, b) && similar4(b, f, d, u)){
				flip = true;
			}
		}
		if((( (similar(f, db) && similar3(u, f, df)) || (similar(uf, d) && similar3(b, d, df)) ) && !similar(c, df))){
			flip = true;
		} 
		
		if(flip){
			dist = _lineWidth-distToLine(point, center+float2(1.0, -1.0)*pointDir, center+float2(-1.0, 1.0)*pointDir, -pointDir);
		} else {
			dist = distToLine(point, center+float2(1.0, 0.0)*pointDir, center+float2(0.0, 1.0)*pointDir, pointDir);
		}
		
		dist -= (_lineWidth/2.0);
		return dist <= 0.0 ? ((distance(c,f) <= distance(c,d)) ? f : d) : -1.0;
	}
	return -1.0;
}

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
	float2 size = 1.0/float2(fPixelWidth, fPixelHeight)+0.00001;
	float2 px = In*size;
	float2 local = floor(fmod(px,1.0)*scale);
	float2 localDiff = (local/1.0) - float2(1.5, 1.5);
	float2 edge = floor(local/(scale/2.0))*(scale/2.0) - float2(1.0, 1.0);
	px = ceil(px);
	
	float4 baseCol = tex2D(img, px/size);
	float4 col = baseCol;
	float4 c = baseCol;
	
	float2 ot = float2(edge.x, edge.y * 4.0);
	float4 t = tex2D(img, floor(px+(float2(0.5,0.5)+ot/4.0))/size);
	float2 otl = float2(edge.x * 4.0, edge.y * 4.0);
	float4 tl = tex2D(img, floor(px+(float2(0.5,0.5)+otl/4.0))/size);
	float2 otr = float2(-edge.x * 4.0, edge.y * 4.0);
	float4 tr = tex2D(img, floor(px+(float2(0.5,0.5)+otr/4.0))/size);
	float2 ol = float2(edge.x * 4.0, edge.y);
	float4 l = tex2D(img, floor(px+(float2(0.5,0.5)+ol/4.0))/size);
	float2 ob = float2(edge.x, -edge.y * 4.0);
	float4 b = tex2D(img, floor(px+(float2(0.5,0.5)+ob/4.0))/size);
	float2 obl = float2(edge.x * 4.0, -edge.y * 4.0);
	float4 bl = tex2D(img, floor(px+(float2(0.5,0.5)+obl/4.0))/size);
	float2 obr = float2(-edge.x * 4.0, -edge.y * 4.0);
	float4 br = tex2D(img, floor(px+(float2(0.5,0.5)+obr/4.0))/size);
	float2 or = float2(-edge.x * 4.0, edge.y);
	float4 r = tex2D(img, floor(px+(float2(0.5,0.5)+or/4.0))/size);
	float2 os = float2(localDiff.x, localDiff.y);
	float4 s = tex2D(img, floor(px+(float2(0.5,0.5)+os/2.0))/size);
	
	//checkerboard special case
	if(!(similar5(c, tl, tr, bl, br) && similar4(t, r, b, l) && higher(t, c))){
		//corner
		if(length(localDiff) > 2.1){
			if(similar(t, l) && !(similar(tl, c) && !higher(t, c))){
				col = t;
			} else if(higher(c, l) && higher(c, t) && (similar(tr, c) || similar(bl, c)) && !similar(tl, c)){
				if(higher(t, l)){
					col = t;
				} else {
					col = l;
				}
			}
		//edge
		} else if(length(localDiff) > 1.58) {
			if(similar(t, l)){
				if(higher(s, c)){
					col = s;
				}
			}
			if(similar3(r, s, tl) && similar3(br, c, l) && higher(s, c)){
				col = t;
			}
			if(!similar(tl, c) && similar3(r, c, bl) && similar3(tr, t, l) && higher(c, l)){
				col = s;
			}
			if(!similar(tr, c) && similar3(l, c, br) && similar3(tl, s, r) && higher(c, r)){
				col = s;
			}
			if(similar3(b, s, tl) && similar3(br, c, t) && higher(b, c)){
				col = s;
			}
			if(!similar(tl, c) && similar3(tr, c, b) && similar3(t, l, bl) && higher(c, l)){
				col = s;
			}
			if(!similar(bl, c) && similar3(br, c, t) && similar3(b, s, tl) && higher(c, s)){
				col = s;
			}
		}
	}
	if(col.a > 0.00001){
		col.a = 1.0;
	}
	return col;
}

technique shader
{
	pass P0
	{
		PixelShader = compile ps_2_a ps_main();
	}
}
