precision highp float;

// Uniforms
uniform int iTime;
uniform vec2 iResolution;
uniform sampler2D prevTexture;

varying vec2 vUV;
varying vec3 p;

uvec3 murmurHash34(uvec4 src) {
    const uint M = 0x5bd1e995u;
    uvec3 h = uvec3(1190494759u, 2147483647u, 3559788179u);
    src *= M; src ^= src>>24u; src *= M;
    h *= M; h ^= src.x; h *= M; h ^= src.y; h *= M; h ^= src.z; h *= M; h ^= src.w;
    h ^= h>>13u; h *= M; h ^= h>>15u;
    return h;
}

// 3 outputs, 4 inputs
vec3 hash34(vec4 src) {
    uvec3 h = murmurHash34(floatBitsToUint(src));
    return uintBitsToFloat(h & 0x007fffffu | 0x3f800000u) - 1.0;
}

float interpolate(float a0, float a1, float w) {
     return (a1 - a0) * ((w * (w * 6.0 - 15.0) + 10.0) * w * w * w) + a0;

}
// r is the spatial coordinate
float perlin_noise(vec3 r, float scale, int seed) {
  // grid coordinates
  vec3 i = floor(r/scale);
  vec3 i0 = vec3(i.x, i.y, i.z)*scale;
  vec3 i1 = vec3(i.x+1., i.y, i.z)*scale;
  vec3 i2 = vec3(i.x, i.y+1., i.z)*scale;
  vec3 i3 = vec3(i.x+1., i.y+1., i.z)*scale;
  vec3 i4 = vec3(i.x, i.y, i.z+1.)*scale;
  vec3 i5 = vec3(i.x+1., i.y, i.z+1.)*scale;
  vec3 i6 = vec3(i.x, i.y+1., i.z+1.)*scale;
  vec3 i7 = vec3(i.x+1., i.y+1., i.z+1.)*scale;
  // dot products
  float p0 = dot(2.*(hash34(vec4(i0, seed)) - .5), (r - i0)/scale);
  float p1 = dot(2.*(hash34(vec4(i1, seed)) - .5), (r - i1)/scale);
  float p2 = dot(2.*(hash34(vec4(i2, seed)) - .5), (r - i2)/scale);
  float p3 = dot(2.*(hash34(vec4(i3, seed)) - .5), (r - i3)/scale);
  float p4 = dot(2.*(hash34(vec4(i4, seed)) - .5), (r - i4)/scale);
  float p5 = dot(2.*(hash34(vec4(i5, seed)) - .5), (r - i5)/scale);
  float p6 = dot(2.*(hash34(vec4(i6, seed)) - .5), (r - i6)/scale);
  float p7 = dot(2.*(hash34(vec4(i7, seed)) - .5), (r - i7)/scale);
  // interpolation weights
  float wx = (r.x - i0.x)/scale;
  float wy = (r.y - i0.y)/scale;
  float wz = (r.z - i0.z)/scale;
  float fx00 = interpolate(p0, p1, wx);
  float fx10 = interpolate(p2, p3, wx);
  float fx01 = interpolate(p4, p5, wx);
  float fx11 = interpolate(p6, p7, wx);
  float fy0 = interpolate(fx00, fx10, wy);
  float fy1 = interpolate(fx01, fx11, wy);
  return interpolate(fy0, fy1, wz);
}

float fractal_noise(vec3 r, float scale, int octaves, float persistence, int seed) {
  float ret = 0.;
  for(int i=0;i<octaves;++i) {
    ret += pow(persistence, float(i))*perlin_noise(r, scale/pow(2., float(i)), seed+i);
  }
  return ret;
}

float contour(float f, float thresh) {
  if (f > thresh) { 
    return 1.; } else {
    return 0.;}
}

void main(void) {

    int random_seed = 3421210;
    float scale = 0.4;

   
    
    float f = fractal_noise(p, scale, 20, 0.8, random_seed)+0.5;
    vec4 tex;

      gl_FragColor = vec4(f, f, f, 1.);

    
      vec4 blurred = vec4(0.0);
      float stencil_half_width = 10.;
      for (float i = -stencil_half_width; i <= stencil_half_width; i++) {
          for (float j = -stencil_half_width; j <= stencil_half_width; j++) {
              vec2 offset = (vec2(i, j)/iResolution);
              blurred += texture2D(prevTexture, vec2(vUV + offset));
          }
      }  
      blurred /= pow(2.*stencil_half_width + 1., 2.);

    
      gl_FragColor = mix(vec4(f, f, f, 1.), blurred, float(iTime > 10));
}