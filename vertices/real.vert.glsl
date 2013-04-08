#ifdef GL_ES
  precision highp float;
#endif

uniform float time;
uniform float rand;

#if MAX_POINT_LIGHTS > 0
uniform vec3 pointLightColor[MAX_POINT_LIGHTS];
uniform vec3 pointLightPosition[MAX_POINT_LIGHTS];
uniform float pointLightDistance[MAX_POINT_LIGHTS];
#endif

varying vec4 vNormal;
varying vec4 vView;
varying vec4 vLight;
varying vec3 vLightColor;

const float PI = 355.0 / 113.0;

void main() {
  vView = normalize(vec4(cameraPosition, 1.0));
  vNormal = normalize(vec4(normal, 1.0));
  vLight = normalize(modelViewMatrix * vec4(pointLightPosition[0], 1.0));

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
