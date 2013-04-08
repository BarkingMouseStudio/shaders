#ifdef GL_ES
  precision highp float;
#endif

varying vec4 vNormal;
varying vec4 vView;
varying vec4 vLight;
varying vec3 vLightColor;

const float PI = 355.0 / 113.0;

float OrenNayar(float roughness, float albedo) {
  float lightRadiance = 0.4;

  float cosThetaI = dot(vLight, vNormal);

  // Regular lambert shading
  if (roughness == 0.0) {
    return albedo * cosThetaI * lightRadiance;
  }

  float vDotN = dot(vView, vNormal);

  float thetaR = acos(vDotN);
  float thetaI = acos(cosThetaI);

  float cosPhiDiff = dot(normalize(vView - vNormal * vDotN), 
    normalize(vLight - vNormal * cosThetaI));
  float maxZeroCosPhiDiff = max(0.0, cosPhiDiff);

  float sigmaSq = roughness * roughness;

  float A = 1.0 - 0.5 * (sigmaSq / (sigmaSq + 0.33));
  float B = 0.45 * (sigmaSq / (sigmaSq + 0.09));

  float alpha = max(thetaI, thetaR);
  float beta = min(thetaI, thetaR);

  return (albedo / PI) *
    cosThetaI *
    (A +
      (B * maxZeroCosPhiDiff * sin(alpha) * tan(beta))
    ) * lightRadiance;
}

void main(void) {
  vec3 tint = normalize(vec3(212.0, 212.0, 256.0));
  float albedo = 0.9;
  float roughness = 0.0;

  float lightIntensity = OrenNayar(roughness, albedo);
  gl_FragColor = vec4(tint * lightIntensity, 1.0);
}
