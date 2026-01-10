// Pixel shader Input structure
struct PS_InPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;

float fR;
float fD;
float fR2;
float angle;

float fPixelWidth; 
float fPixelHeight; 

// Helper function to adjust alpha for antialiasing based on distance to the edge
float adjustAlphaForAntialiasing(float distToEdge)
{
    // fAntialiasWidth defines the distance over which the antialiasing effect occurs
    float fAntialiasWidth = 0.005;
    return saturate(1.0 - (abs(distToEdge) / fAntialiasWidth));
}

PS_OUTPUT ps_maIn( in PS_InPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0,In.Texture);
	
	float deg2rad = 0.017453;
	//pi/180
	float xcenter=0.5*fPixelHeight;
	float ycenter=0.5*fPixelWidth;
	float xr=fR*fPixelWidth;
	float yr=fR*fPixelHeight;
	
	fR2=fR-fD;
	float xr2=fR2*fPixelWidth;
	float yr2=fR2*fPixelHeight;
	
	//float alpha=1;
	float alpha=Out.Color.a;

    float a = 0; // alpha value
	
	if((pow((In.Texture.y-0.5)/yr,2)+pow((In.Texture.x-0.5)/xr,2)<=1)&&(pow((In.Texture.y-0.5)/yr2,2)+pow((In.Texture.x-0.5)/xr2,2)>=1))
	{
		a=Out.Color.a;
		if(angle < 0)
		{
			a=0;
		}			
		else if(angle <= 90)
		{
            if((In.Texture.x < 0.5)||(In.Texture.y > 0.5))
			{
				a=0;
			}
			else if (In.Texture.y < 0.5 && abs(0.5 -In.Texture.y) >= abs(0.5 -In.Texture. x) * tan((90-angle) * deg2rad))
			{
				a=alpha;
			}
			else
			{
				a=0;
			}
        }
		else if(angle <= 180)
		{
            if(In.Texture.x < 0.5)
			{
				a=0;
			}
			else if((In.Texture.x > 0.5)&&(In.Texture.y < 0.5))
			{
				a=alpha;
			}
			else if (In.Texture.y > 0.5 && abs(0.5 -In.Texture.y) <= abs(0.5 -In.Texture. x) * tan((angle-90) * deg2rad))
			{
				a=alpha;
			}
			else
			{
				a=0;
			}
        }
		else if(angle <= 270)
		{
            if((In.Texture.x < 0.5)&&(In.Texture.y < 0.5))
			{
				a=0;
			}
			if(In.Texture.x > 0.5)
			{
				a=alpha;
			}			
			else if (In.Texture.y > 0.5 && abs(0.5 -In.Texture.y) >= abs(0.5 -In.Texture. x) * tan((270-angle) * deg2rad))
			{
				a=alpha;
			}
			else
			{
				a=0;
			}
        }
		else if(angle <= 360)
		{           
			if((In.Texture.x > 0.5)||(In.Texture.y > 0.5))
			{
				a=alpha;
			}
			else if (In.Texture.y < 0.5 && abs(0.5 -In.Texture.y) <= abs(0.5 -In.Texture. x) * tan((angle-270) * deg2rad))
			{
				a=alpha;
			}
			else
			{
				a=0;
			}
        }      
	}
	
    // If the pixel is inside the pie chart, adjust its alpha for antialiasing
    if (a > 0)
    {
        float distToOuterEdge = fR - sqrt(pow((In.Texture.y-0.5)*fPixelHeight,2) + pow((In.Texture.x-0.5)*fPixelWidth,2));
        float distToInnerEdge = sqrt(pow((In.Texture.y-0.5)*fPixelHeight,2) + pow((In.Texture.x-0.5)*fPixelWidth,2)) - fR2;
        
        // Adjust alpha for antialiasing based on the distances to the edges
        a *= adjustAlphaForAntialiasing(distToOuterEdge);
        a *= adjustAlphaForAntialiasing(distToInnerEdge);
        
        // Additional logic to adjust alpha for antialiasing for the angled edge
        // This will be more complex and will involve calculating the distance from the pixel to the line defined by the angle
        // This part is left as a placeholder for now, and might require more detailed calculations
    }
    
    Out.Color.a = a;
    return Out;
}


// Effect technique
technique tech_maIn
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_maIn();
    }  
}