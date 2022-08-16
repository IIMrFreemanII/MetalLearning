#include <metal_stdlib>
using namespace metal;
#import "Common.h"

struct VertexIn {
  float4 position [[attribute(0)]];
};

struct VertexOut {
  float4 position [[position]];
};

vertex VertexOut vertex_main(
                             VertexIn in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(11)]]
                             )
{
  float4 position =
  uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position;
  VertexOut out {
    .position = position
  };
  return out;
}

fragment float4 fragment_main(
                              constant Params &params [[buffer(12)]],
                              VertexOut in [[stage_in]]
                              )
{
  float color;
  in.position.x < params.width * 0.5 ? color = 0 : color = 1;
  return float4(color, color, color, 1);
}
