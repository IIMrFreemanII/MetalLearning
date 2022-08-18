//
//  Number4Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number4Field<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var value: SIMD4<T>
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(value: $value.x)
        NumberField(value: $value.y)
        NumberField(value: $value.z)
        NumberField(value: $value.w)
      }
    }
    .enableInjection()
  }
}

struct Number4Field_Previews: PreviewProvider {
    static var previews: some View {
      Number4Field(label: "", value: .constant([0, 0, 0, 0]))
    }
}
