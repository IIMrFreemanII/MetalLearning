//
//  Number4Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number4Field<T: Numeric>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var x: T
  @Binding var y: T
  @Binding var z: T
  @Binding var w: T
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(label: "X", value: $x)
        NumberField(label: "Y", value: $y)
        NumberField(label: "Z", value: $z)
        NumberField(label: "W", value: $z)
      }
    }
    .enableInjection()
  }
}

struct Number4Field_Previews: PreviewProvider {
    static var previews: some View {
      Number4Field(label: "", x: .constant(0), y: .constant(0), z: .constant(0), w: .constant(0))
    }
}
