//
//  Number2Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number2Field<T: Numeric>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var x: T
  @Binding var y: T
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(label: "X", value: $x)
        NumberField(label: "Y", value: $y)
      }
    }
    .enableInjection()
  }
}

struct Number2Field_Previews: PreviewProvider {
  static var previews: some View {
    Number2Field(label: "", x: .constant(0), y: .constant(0))
  }
}
