sampler2D img = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};
float radius,fPixelWidth,fPixelHeight;

#define iterations 30

const float2 offsets[iterations] = {
1, -0,
0.489074, -0.103956,
0.913545, -0.406737,
0.404509, -0.293893,
0.669131, -0.743145,
0.25, -0.433013,
0.309017, -0.951057,
0.0522642, -0.497261,
-0.104529, -0.994522,
-0.154509, -0.475528,
-0.5, -0.866025,
-0.334565, -0.371572,
-0.809017, -0.587785,
-0.456773, -0.203368,
-0.978148, -0.207912,
-0.5, -0,
-0.978148, 0.207912,
-0.456773, 0.203368,
-0.809017, 0.587786,
-0.334565, 0.371572,
-0.5, 0.866025,
-0.154509, 0.475528,
-0.104528, 0.994522,
0.0522642, 0.497261,
0.309017, 0.951056,
0.25, 0.433013,
0.669131, 0.743145,
0.404508, 0.293893,
0.913546, 0.406736,
0.489074, 0.103956,
};

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    float4 o = tex2D(img,In);	
    for(int i=0;i<iterations;i++)
        o += tex2D(img,In+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]);
    o /= iterations+1;
    return o;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }