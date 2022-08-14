//
//  Number4x4Field.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject

struct Number4x4Field<T: Numeric>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var x1: T
  @Binding var y1: T
  @Binding var z1: T
  @Binding var w1: T
  
  @Binding var x2: T
  @Binding var y2: T
  @Binding var z2: T
  @Binding var w2: T
  
  @Binding var x3: T
  @Binding var y3: T
  @Binding var z3: T
  @Binding var w3: T
  
  @Binding var x4: T
  @Binding var y4: T
  @Binding var z4: T
  @Binding var w4: T
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(label: "X", value: $x1)
        NumberField(label: "Y", value: $y1)
        NumberField(label: "Z", value: $z1)
        NumberField(label: "W", value: $w1)
      }
      HStack {
        NumberField(label: "X", value: $x2)
        NumberField(label: "Y", value: $y2)
        NumberField(label: "Z", value: $z2)
        NumberField(label: "W", value: $w2)
      }
      HStack {
        NumberField(label: "X", value: $x3)
        NumberField(label: "Y", value: $y3)
        NumberField(label: "Z", value: $z3)
        NumberField(label: "W", value: $w3)
      }
      HStack {
        NumberField(label: "X", value: $x4)
        NumberField(label: "Y", value: $y4)
        NumberField(label: "Z", value: $z4)
        NumberField(label: "W", value: $w4)
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
