//
//  Number3x3Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number3x3Field: View {
  @ObserveInjection private var inject
  
  let label: String
  @Binding var matrix: float3x3
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      VStack {
        HStack {
          NumberField(value: $matrix[0][0])
          NumberField(value: $matrix[0][1])
          NumberField(value: $matrix[0][2])
        }
        HStack {
          NumberField(value: $matrix[1][0])
          NumberField(value: $matrix[1][1])
          NumberField(value: $matrix[1][2])
        }
        HStack {
          NumberField(value: $matrix[2][0])
          NumberField(value: $matrix[2][1])
          NumberField(value: $matrix[2][2])
        }
      }
    }
    .enableInjection()
  }
}

struct Number3x3Field_Previews: PreviewProvider {
  static var previews: some View {
    Number3x3Field(label: "Test", matrix: .constant(
      float3x3(
        [1, 0, 0],
        [0, 1, 0],
        [1, 1, 1]
      )
    ))
  }
}
