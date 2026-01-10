// Voxel Model Shader
// v2
// By MuddyMole / Sketchy / Adam Hawker

// Pixel shader input structure.
struct PS_INPUT {
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Texture sampler.
Texture2D<float4> imageModel : register(t1);
sampler imageSampler : register(s1);

// Declare the parameters imported from CF2.5.
cbuffer PS_VARIABLES:register(b0) {
  int offsetX, offsetY, offsetZ;
  uint imageWidth, imageHeight, imageRows, imageColumns, imageFirstFrame, imageLastFrame, rotateOrder, lightAmbient, lightDirectional, fog;
  float rotateX, rotateY, rotateZ, cameraDistance, cameraClipNear, cameraClipFar, cameraMagnify, lightX, lightY, lightZ, fogNear, fogFar;
}

// Get the size of the object.
cbuffer PS_PIXELSIZE : register(b1) {
  float fPixelWidth;
  float fPixelHeight;
};

// Correct for premultipled alpha.
float4 Demultiply(float4 _color) {
  float4 color = _color;
  if ( color.a != 0 ) { color.xyz /= color.a; }
  return color;
}

// Define a helper function to rotate any float3 vector about the X axis.
float3 rotationX(float3 vec, float ang) {
  return float3(vec.x, (vec.y * cos(ang)) - (vec.z * sin(ang)), (vec.y * sin(ang)) + (vec.z * cos(ang)));
}

// Define a helper function to rotate any float3 vector about the Y axis.
float3 rotationY(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) + (vec.z * sin(ang)), vec.y, (vec.z * cos(ang)) - (vec.x * sin(ang))); 
}

// Define a helper function to rotate any float3 vector about the Z axis.
float3 rotationZ(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) - (vec.y * sin(ang)), (vec.x * sin(ang)) + (vec.y * cos(ang)), vec.z);
}

// Define a function to find the colour of a voxel.
float4 getPixel(float3 position) {
  float4 voxelColor = float4(0.0, 0.0, 0.0, 0.0);
  int3 pos = round(position);
  int3 frameDim = float3(imageWidth / imageColumns, imageHeight / imageRows, imageLastFrame + 1 - imageFirstFrame);
  int withinFrameX = int((frameDim.x * 0.5) + pos.x + offsetX);
  int withinFrameY = int((frameDim.y * 0.5) + pos.y + offsetY);
  int withinFrameZ = int((frameDim.z * 0.5) + pos.z + offsetZ);
  int frameId = imageFirstFrame + withinFrameZ;
  if (withinFrameX < 0 || withinFrameX >= frameDim.x || withinFrameY < 0 || withinFrameY >= frameDim.y || frameId < int(imageFirstFrame) || frameId > int(imageLastFrame)) {
    return voxelColor;
  }
  uint frameColumn = frameId % imageColumns;
  uint frameRow = floor(frameId / imageColumns);
  float pixelX = 1.0 * ((frameColumn * frameDim.x) + withinFrameX) / imageWidth;
  float pixelY = 1.0 * ((frameRow * frameDim.y) + withinFrameY) / imageHeight;
  return imageModel.SampleLevel(imageSampler, float2(pixelX, pixelY), 0);
}

// Main shader function.
float4 effect(PS_INPUT In, bool PM ) : SV_TARGET {

// Declare some variables to be used later.
float4 voxel = float4(0.0, 0.0, 0.0, 0.0);
float4 outColor = float4(0.0, 0.0, 0.0, 0.0);
float3 surfaceNormal = float3(0.0, 0.0, 0.0);
float3 lightDirection = normalize(float3(lightX, lightY, lightZ));

// Convert rotation angles from degrees to radians.
float angleX = radians(rotateX);
float angleY = radians(rotateY);
float angleZ = radians(rotateZ);

// Instead of texture units, use pixels as coordinates, with 0,0,0 being at the centre of the model.
float3 target = float3((In.texCoord.x - 0.5) / fPixelWidth / cameraMagnify, (In.texCoord.y - 0.5) / fPixelHeight / cameraMagnify, 0.0);
float3 camera = float3(0.0, 0.0, 0.0 - cameraDistance);
float3 origin = float3(0.5 / fPixelWidth, 0.5 / fPixelHeight, 0.0);

// Rotate the camera and target around the origin.
int3x1 orderOfRotation = { floor(rotateOrder / 100), floor((rotateOrder % 100) / 10), rotateOrder % 10 };
for (int r=0; r<3; r++) {
  switch (orderOfRotation[r][0]) {
    case 1:
      target = rotationX(target, angleX);
      camera = rotationX(camera, angleX);
      break;
    case 2:
      target = rotationY(target, angleY);
      camera = rotationY(camera, angleY);
      break;
    case 3:
      target = rotationZ(target, angleZ);
      camera = rotationZ(camera, angleZ);
      break;
  }
}

// Trace a ray from the camera to the target.
float3 rayDirection = normalize(target - camera);
float3 ray = camera + (rayDirection * cameraClipNear);
float rayLength = cameraClipNear;
for (int i=0; i<200; i++) {
  rayLength++;
  if (rayLength > cameraClipFar) {
    break;
  }
  ray += rayDirection;
    voxel = getPixel(ray);
    if (voxel.a > 0.0) {
      outColor = voxel;
      // Check which neighbouring voxels are empty, and use that to calculate the surface normal.
      if (getPixel(ray + float3( 1.0,  1.0,  1.0)).a == 0.0) { surfaceNormal.x++; surfaceNormal.y++; surfaceNormal.z++;}
      if (getPixel(ray + float3( 1.0,  1.0, -1.0)).a == 0.0) { surfaceNormal.x++; surfaceNormal.y++; surfaceNormal.z--;}
      if (getPixel(ray + float3( 1.0, -1.0,  1.0)).a == 0.0) { surfaceNormal.x++; surfaceNormal.y--; surfaceNormal.z++;}
      if (getPixel(ray + float3( -1.0,  1.0,  1.0)).a == 0.0) { surfaceNormal.x--; surfaceNormal.y++; surfaceNormal.z++;}
      if (getPixel(ray + float3( -1.0, -1.0, -1.0)).a == 0.0) { surfaceNormal.x--; surfaceNormal.y--; surfaceNormal.z--;}
      if (getPixel(ray + float3( -1.0, -1.0,  1.0)).a == 0.0) { surfaceNormal.x--; surfaceNormal.y--; surfaceNormal.z++;}
      if (getPixel(ray + float3( -1.0,  1.0, -1.0)).a == 0.0) { surfaceNormal.x--; surfaceNormal.y++; surfaceNormal.z--;}
      if (getPixel(ray + float3(  1.0, -1.0, -1.0)).a == 0.0) { surfaceNormal.x++; surfaceNormal.y--; surfaceNormal.z--;}
      if (getPixel(ray + float3( -1.0,  0.0,  0.0)).a == 0.0) { surfaceNormal.x--;}
      if (getPixel(ray + float3(  1.0,  0.0,  0.0)).a == 0.0) { surfaceNormal.x++;}
      if (getPixel(ray + float3(  0.0, -1.0,  0.0)).a == 0.0) { surfaceNormal.y--;}
      if (getPixel(ray + float3(  0.0,  1.0,  0.0)).a == 0.0) { surfaceNormal.y++;}
      if (getPixel(ray + float3(  0.0,  0.0, -1.0)).a == 0.0) { surfaceNormal.z--;}
      if (getPixel(ray + float3(  0.0,  0.0,  1.0)).a == 0.0) { surfaceNormal.z++;}
      for (int n=0; n<3; n++) {
        switch (orderOfRotation[2-n][0]) {
          case 1:
            surfaceNormal = rotationX(surfaceNormal, 0.0 - angleX);
            break;
          case 2:
            surfaceNormal = rotationY(surfaceNormal, 0.0 - angleY);
            break;
          case 3:
            surfaceNormal = rotationZ(surfaceNormal, 0.0 - angleZ);
            break;
        }
      }
      // Unpack red, green and blue components from combined ints.
      float3 ambient = float3(float(lightAmbient & 255u) / 255.0, float(lightAmbient >> 8 & 255u) / 255.0, float(lightAmbient >> 16 & 255u) / 255.0);
      float3 directional = float3(float(lightDirectional & 255u) / 255.0, float(lightDirectional >> 8 & 255u) / 255.0, float(lightDirectional >> 16 & 255u) / 255.0);
      float3 fogColor = float3(float(fog & 255u) / 255.0, float(fog >> 8 & 255u) / 255.0, float(fog >> 16 & 255u) / 255.0);
      
      // Apply combined directional and ambient lighting.
      outColor.rgb *= ((max(0.0, dot(normalize(surfaceNormal), lightDirection)) * directional.rgb) + ambient );

      // Apply fog effect.
      float fogDensity = min(max((rayLength - fogNear) / (fogFar - fogNear), 0.0), 1.0);
      outColor.rgb = lerp(outColor.rgb, fogColor, fogDensity);
      outColor.a = 1.0;
      break;
    }
}
if (PM) {
  outColor.rgb *= outColor.a;
}
return outColor * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}