//
//  Number3x3Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number3x3Field<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var c0: SIMD3<T>
  @Binding var c1: SIMD3<T>
  @Binding var c2: SIMD3<T>
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        VStack {
          NumberField(value: $c0[0])
          NumberField(value: $c0[1])
          NumberField(value: $c0[2])
        }
        VStack {
          NumberField(value: $c1[0])
          NumberField(value: $c1[1])
          NumberField(value: $c1[2])
        }
        VStack {
          NumberField(value: $c2[0])
          NumberField(value: $c2[1])
          NumberField(value: $c2[2])
        }
      }
    }
    .enableInjection()
  }
}

//struct Number3x3Field_Previews: PreviewProvider {
//    static var previews: some View {
//        Number3x3Field()
//    }
//}
