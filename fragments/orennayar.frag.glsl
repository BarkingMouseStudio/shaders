#ifdef GL_ES
  precision highp float;
#endif

varying vec4 vNormal;
varying vec4 vLight;
varying vec4 vView;

const float PI = 355.0 / 113.0;

float oren_nayar(float roughness, float albedo) {
  float light_radiance = 1.0;

  float cos_theta_i = dot(vLight, vNormal);
  float reflected_light;

  // Regular lambert shading
  if (roughness == 0.0) {
    reflected_light =
      albedo *
      cos_theta_i *
      light_radiance;
    return reflected_light;
  }

  float v_dot_n = dot(vView, vNormal);

  float theta_r = acos(v_dot_n);
  float theta_i = acos(cos_theta_i);

  float cos_phi_diff = dot(normalize(vView - vNormal * v_dot_n), 
    normalize(vLight - vNormal * cos_theta_i));
  float max_zero_cos_phi_diff = max(0.0, cos_phi_diff);

  float sigma_sq = roughness * roughness;

  float A = 1.0 - 0.5 *
    (sigma_sq / (sigma_sq + 0.33));
  float B = 0.45 *
    (sigma_sq / (sigma_sq + 0.09));

  float alpha = max(theta_i, theta_r);
  float beta = min(theta_i, theta_r);

  reflected_light =
    albedo *
    cos_theta_i *
    (A +
      (B *
        max_zero_cos_phi_diff *
        sin(alpha) *
        tan(beta)
      )
    ) * light_radiance;

  return reflected_light;
}

void main(void) {
  vec3 tint = normalize(vec3(212.0, 212.0, 256.0));

  float albedo = 0.9;
  float roughness = 0.5;

  gl_FragColor = vec4(tint *
    oren_nayar(roughness, albedo), 1.0);
}
