//
//  Number3Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number3Field<T: Numeric>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var x: T
  @Binding var y: T
  @Binding var z: T
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(value: $x)
        NumberField(value: $y)
        NumberField(value: $z)
      }
    }
    .enableInjection()
  }
}

struct Number3Field_Previews: PreviewProvider {
    static var previews: some View {
        Number3Field(label: "", x: .constant(0), y: .constant(0), z: .constant(0))
    }
}
