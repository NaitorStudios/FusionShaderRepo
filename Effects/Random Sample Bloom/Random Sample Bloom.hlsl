
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

//Texture2D<float4> bg : register(t1);
//sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float radius;
	float thresh;
	float multiplier ;
	float boost;
	
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

#define iterations 180


//Thanks to
//http://www.klopfenstein.net/lorenz.aspx/gamecomponents-the-bloom-post-processing-filter
static const float2 offsets[iterations] = {

0.1625,0.028125,
0.071875,0.065625,
0.0125,-0.009375,
0.00625,-0.003125,
-0.071875,0.08125,
-0.128125,0.165625,
-0.0125,-0.040625,
-0.0125,0.003125,
-0.015625,0.046875,
0,-0.028125,
-0.01875,-0.221875,
-0.053125,-0.046875,
0.003125,0.0125,
0.06875,-0.10625,
0.1875,0.01875,
0.165625,0.14375,
0.153125,0.19375,
0.021875,0.015625,
-0.078125,0.165625,
-0.19375,0.140625,
-0.14375,0.0625,
-0.109375,-0.14375,
-0.075,-0.1,
0.034375,-0.103125,
0.096875,-0.265625,
0.103125,-0.1,
0.09375,-0.0375,
0.153125,0.103125,
0.171875,0.01875,
0.0875,0.265625,
-0.00625,0.29375,
-0.03125,0.115625,
-0.0625,0.121875,
-0.253125,0.05,
-0.25,0.03125,
-0.225,-0.278125,
-0.14375,-0.190625,
-0.015625,-0.20625,
0.165625,-0.153125,
0.246875,-0.2125,
0.35625,0.01875,
0.2375,0.23125,
0.1,0.184375,
-0.021875,0.3,
-0.140625,0.328125,
-0.2375,0.30625,
-0.25,-0.01875,
-0.203125,-0.0375,
-0.190625,-0.140625,
-0.159375,-0.3375,
-0.034375,-0.390625,
0.109375,-0.28125,
0.184375,-0.09375,
0.303125,-0.1125,
0.409375,0.1375,
0.29375,0.29375,
0.1375,0.396875,
-0.053125,0.2375,
-0.259375,0.30625,
-0.375,0.240625,
-0.3875,-0.0375,
-0.29375,-0.2375,
-0.153125,-0.24375,
0.0375,-0.3,
0.165625,-0.5,
0.2875,-0.25,
0.30625,-0.065625,
0.378125,0.09375,
0.346875,0.20625,
0.228125,0.453125,
0.003125,0.509375,
-0.11875,0.284375,
-0.321875,0.259375,
-0.4625,0.071875,
-0.51875,-0.0875,
-0.334375,-0.45,
-0.15,-0.375,
0.040625,-0.36875,
0.359375,-0.384375,
0.53125,-0.246875,
0.5375,0.03125,
0.41875,0.34375,
0.253125,0.33125,
0.003125,0.54375,
-0.234375,0.51875,
-0.371875,0.390625,
-0.45,0.05625,
-0.4625,-0.08125,
-0.4375,-0.253125,
-0.29375,-0.515625,
-0.040625,-0.5125,
0.196875,-0.421875,
0.396875,-0.184375,
0.5625,-0.215625,
0.6375,0.1875,
0.44375,0.46875,
0.1625,0.5375,
-0.11875,0.46875,
-0.428125,0.509375,
-0.634375,0.346875,
-0.61875,-0.0625,
-0.484375,-0.275,
-0.284375,-0.4375,
-0.065625,-0.54375,
0.190625,-0.7,
0.384375,-0.38125,
0.496875,-0.134375,
0.64375,0.071875,
0.55,0.325,
0.41875,0.628125,
0.065625,0.721875,
-0.234375,0.45,
-0.51875,0.40625,
-0.7,0.125,
-0.740625,-0.15625,
-0.478125,-0.553125,
-0.209375,-0.571875,
0.1125,-0.603125,
0.4625,-0.609375,
0.684375,-0.303125,
0.73125,-0.00625,
0.590625,0.4125,
0.4375,0.471875,
0.125,0.7625,
-0.271875,0.796875,
-0.45625,0.540625,
-0.6125,0.2,
-0.728125,-0.071875,
-0.665625,-0.325,
-0.415625,-0.796875,
-0.090625,-0.721875,
0.2625,-0.625,
0.590625,-0.4125,
0.80625,-0.2375,
0.88125,0.259375,
0.5625,0.61875,
0.203125,0.721875,
-0.1875,0.8,
-0.553125,0.69375,
-0.78125,0.5,
-0.740625,-0.06875,
-0.684375,-0.384375,
-0.44375,-0.60625,
-0.1375,-0.825,
0.215625,-0.9125,
0.4625,-0.565625,
0.7125,-0.14375,
0.853125,0.0625,
0.784375,0.515625,
0.459375,0.83125,
0.08125,0.940625,
-0.3875,0.675,
-0.734375,0.58125,
-0.928125,0.228125,
-0.840625,-0.253125,
-0.646875,-0.709375,
-0.209375,-0.84375,
0.209375,-0.84375,
0.59375,-0.875,
0.828125,-0.425,
0.925,0.046875,
0.775,0.4875,
0.584375,0.684375,
0.15,1.06563,
-0.3,1.0125,
-0.603125,0.6,
-0.84375,0.290625,
-0.9875,-0.125,
-0.853125,-0.5,
-0.46875,-1.00313,
-0.015625,-0.96875,
0.415625,-0.83125,
0.825,-0.53125,
1.07187,-0.196875,
1.00313,0.3625,
0.659375,0.834375,
0.225,0.915625,
-0.2375,1.025,
-0.70625,0.871875,
-0.95,0.55,

};

float4 threshold(float4 i)
{  
     //Make everything under the threshold value black, then "stretch" the remainder to fill the whole 0-1 range.
	return max( abs(i) - float4(thresh,thresh,thresh,0) + float4(boost,boost,boost,0), float4(0,0,0,0) ) * float4(multiplier,multiplier,multiplier,1);
          
     //Alternative threshold function: makes less colorful blooms. Better for "soft focus" effects
     //float3 rgb = i.rgb;
     //float avg = (rgb.r + rgb.g + rgb.b)/3.0;
	//return float4(abs(rgb)*step(thresh, abs(avg)), 1);

}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{ 

   //Set up the sampler. Start it out the same at the input s
   float4 s = img.Sample(imgSampler,In.texCoord);
   float4 o = {0,0,0,0};

   //Do blurring procedure using the precomputed values of the circle. You could do this mathematically with sin and cos, not sure which is better...
   [unroll]
   for(int i=0;i<iterations;i++) {
    //We want to add a value that is inversely proportional to the length of the vector:
    //Note the 5.0 at the end refers to mip map level 5. If mip maps were to be enabled in Fusion this "should" work automatically and look much better.
    o += (1.0 - abs(length(float2(offsets[i].x,offsets[i].y)))) * threshold(img.SampleLevel(imgSampler,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i],5.0));
    }
        
   //Finally, return the original image (s) plus the thresh'd and blurred image aka bloom (o):
   //The 0.01 is arbitrary here, this could be another variable. Basically we want only a fraction of the accumulated samples' brightness for the "bloom" effect
   return float4(s.rgb+o.rgb*0.01, s.a);  
  
  //return float4(o.rgb*0.01,1); 

}

