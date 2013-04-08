#ifdef GL_ES
  precision highp float;
#endif

uniform float time;
uniform float rand;

varying vec4 vNormal;
varying vec4 vView;
varying vec4 vLight;

const float PI = 355.0 / 113.0;

void main() {
  float lightRadius = 2.0;
  vLight = normalize(vec4(
    sin(mod(time, PI * 2.0)) * lightRadius,
    cos(mod(time, PI * 2.0)) * lightRadius,
    sin(mod(time, PI * 2.0)) * lightRadius,
    1.0));
  vView = vec4(0.0);
  vNormal = normalize(vec4(normal, 1.0));

  gl_Position =
    projectionMatrix *
    modelViewMatrix *
    vec4(position, 1.0);
}
