//
//  Number4x4Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number4x4Field: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var matrix: float4x4
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      VStack {
        HStack {
          NumberField(value: $matrix[0][0])
          NumberField(value: $matrix[0][1])
          NumberField(value: $matrix[0][2])
          NumberField(value: $matrix[0][3])
        }
        HStack {
          NumberField(value: $matrix[1][0])
          NumberField(value: $matrix[1][1])
          NumberField(value: $matrix[1][2])
          NumberField(value: $matrix[1][3])
        }
        HStack {
          NumberField(value: $matrix[2][0])
          NumberField(value: $matrix[2][1])
          NumberField(value: $matrix[2][2])
          NumberField(value: $matrix[2][3])
        }
        HStack {
          NumberField(value: $matrix[3][0])
          NumberField(value: $matrix[3][1])
          NumberField(value: $matrix[3][2])
          NumberField(value: $matrix[3][3])
        }
      }
    }
    .enableInjection()
  }
}

struct Number4x4Field_Previews: PreviewProvider {
    static var previews: some View {
      Number4x4Field(label: "Test", matrix: .constant(.identity))
    }
}
