//
//  NumberField.swift
//  MetalLearning
//
//  Created by Nikolay Diahovets on 14.08.2022.
//

import SwiftUI
import Inject


struct NumberField<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  @Binding var value: T
  
  func getFormatter() -> Formatter {
    switch value {
    case is Int:
      return intFormatter
    case is Double:
      return decimalFormatter
    case is Float:
      return decimalFormatter
    default:
      return Formatter()
    }
  }
  
  var body: some View {
    TextField("", value: $value, formatter: getFormatter())
    .textFieldStyle(.roundedBorder)
    .enableInjection()
  }
}

struct NumberField_Previews: PreviewProvider {
  static var previews: some View {
    NumberField(value: .constant(0))
  }
}
