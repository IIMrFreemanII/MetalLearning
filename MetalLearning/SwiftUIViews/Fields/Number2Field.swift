//
//  Number2Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number2Field<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var value: SIMD2<T>
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(value: $value.x)
        NumberField(value: $value.y)
      }
    }
    .enableInjection()
  }
}

struct Number2Field_Previews: PreviewProvider {
  static var previews: some View {
    Number2Field(label: "", value: .constant([0, 0]))
  }
}
