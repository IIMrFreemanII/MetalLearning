//
//  Number4x4Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number4x4Field<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var c0: SIMD4<T>
  @Binding var c1: SIMD4<T>
  @Binding var c2: SIMD4<T>
  @Binding var c3: SIMD4<T>
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        VStack {
          NumberField(value: $c0[0])
          NumberField(value: $c0[1])
          NumberField(value: $c0[2])
          NumberField(value: $c0[3])
        }
        VStack {
          NumberField(value: $c1[0])
          NumberField(value: $c1[1])
          NumberField(value: $c1[2])
          NumberField(value: $c1[3])
        }
        VStack {
          NumberField(value: $c2[0])
          NumberField(value: $c2[1])
          NumberField(value: $c2[2])
          NumberField(value: $c2[3])
        }
        VStack {
          NumberField(value: $c3[0])
          NumberField(value: $c3[1])
          NumberField(value: $c3[2])
          NumberField(value: $c3[3])
        }
      }
    }
    .enableInjection()
  }
}

//struct Number4x4Field_Previews: PreviewProvider {
//    static var previews: some View {
//        Number4x4Field()
//    }
//}
