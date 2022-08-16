#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDefs.h"

struct VertexIn {
  float4 position [[attribute(0)]];
  float3 normal [[attribute(1)]];
};

vertex VertexOut vertex_main(
                             VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]
                             )
{
  float4 position =
  uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
  float3 normal = in.normal;
  
  VertexOut out {
    .position = position,
    .normal = normal
  };
  return out;
}

fragment float4 fragment_main(
                              constant Params &params [[buffer(ParamsBuffer)]],
                              VertexOut in [[stage_in]]
                              )
{
  return float4(in.normal, 1);
}
