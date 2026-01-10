sampler2D img : register(s0);

// Reference colors (Not Editable)
static const float4 redFilter = float4(1.0, 0.0, 0.0, 1.0);
static const float4 greenFilter = float4(0.0, 1.0, 0.0, 1.0);
static const float4 blueFilter = float4(0.0, 0.0, 1.0, 1.0);
static const float4 yellowFilter = float4(1.0, 1.0, 0.0, 1.0);
static const float4 purpleFilter = float4(1.0, 0.0, 1.0, 1.0);
static const float4 cyanFilter = float4(0.0, 1.0, 1.0, 1.0);
static const float4 whiteFilter = float4(1.0, 1.0, 1.0, 1.0);

// Dynamic Replacement Colors (Editable via XML)
float4 red;
float4 green;
float4 blue;
float4 yellow;
float4 purple;
float4 cyan;
float4 white;

// Dynamic Lerp Values (Editable via XML)
float redLerp;
float greenLerp;
float blueLerp;
float yellowLerp;
float purpleLerp;
float cyanLerp;
float whiteLerp;

float dis(float4 _color, float4 c){
float result = (pow(_color.r - c.r,2.0)+pow(_color.g - c.g,2.0)+pow(_color.b - c.b,2.0));
return result;
}

float4 applyReplacement(float4 originalColor, float4 filterColor, float4 replacementColor, float lerpValue) {
	float distance = dis(originalColor, filterColor);
	// Adjust the usage of smoothstep based on the actual distance calculation.
	float factor = smoothstep(0.0, lerpValue, sqrt(distance));
	// Lerp between transparent (assuming this means no change) and the replacement color.
	return lerp(float4(0, 0, 0, 0), replacementColor, factor);
}

// Main pixel shader function adjustments.
float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR {
	float4 _color = tex2D(img, texCoord);
	float4 Red, Blue, Green, Yellow, Purple, Cyan, White;

	if (_color.a > 0.15) {
		// Apply color replacements.
		float4 transparent = float4(0,0,0,0);
		Red = lerp(red,transparent,smoothstep(0,redLerp,dis(_color,redFilter)));
		Green = lerp(green,transparent,smoothstep(0,greenLerp,dis(_color,greenFilter)));
		Blue = lerp(blue,transparent,smoothstep(0,blueLerp,dis(_color,blueFilter)));
		Yellow = lerp(yellow,transparent,smoothstep(0,yellowLerp,dis(_color,yellowFilter)));
		Purple = lerp(purple,transparent,smoothstep(0,purpleLerp,dis(_color,purpleFilter)));
		Cyan = lerp(cyan,transparent,smoothstep(0,cyanLerp,dis(_color,cyanFilter)));
		White = lerp(white,transparent,smoothstep(0,whiteLerp,dis(_color,whiteFilter)));
	}
	else {
		_color = float4(0, 0, 0, 0);
	}
	
	return _color + (Green + Red + Blue + Yellow + Purple + Cyan + White);
}

technique ColorReplacementTechnique {
	pass P0 {
		PixelShader = compile ps_2_b ps_main();
	}
}