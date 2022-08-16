//
//  ShaderDefs.h
//  MetalLearning
//
//  Created by Nikolay Diahovets on 16.08.2022.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

using namespace metal;

struct VertexOut {
  float4 position [[position]];
  float3 normal;
};

#endif /* ShaderDefs_h */
