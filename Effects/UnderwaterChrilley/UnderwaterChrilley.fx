//Enable texture wrap
sampler2D bkd : register(s1)= sampler_state{
   AddressU = Wrap;
   AddressV =   Wrap;
};
sampler2D distort : register(s2)= sampler_state{
   AddressU =   Wrap;
   AddressV =   Wrap;
};

float fAmplitude, fFrequency, fPeriods, fDistortStr, fWaveFrequency, fWaveAmplitude, fWavePeriods, fPixelWidth, fPixelHeight;
bool waveEnabled;
float4 fColor;
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {

float4 color = tex2D(bkd, float2( In.x,In.y));

float4 distortColor = tex2D(distort, float2( In.x,In.y));

float2 offset = float2(fFrequency*fPixelWidth, fFrequency*fPixelHeight);
offset.x = distortColor.r*fDistortStr;
offset.y = distortColor.g*fDistortStr;

color =  tex2D(bkd, float2(In.x+ (sin((In.x+fFrequency)*fPeriods)*fAmplitude)+offset.x,In.y+ (sin((In.x+fFrequency)*fPeriods)*fAmplitude)+offset.y));

color += fColor;

if(waveEnabled){
color.a = smoothstep(0.01,0.03, In.y+(sin((In.x+fWaveFrequency*fPixelHeight)*fWavePeriods)*fWaveAmplitude)+offset);
}
return color;

}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }


