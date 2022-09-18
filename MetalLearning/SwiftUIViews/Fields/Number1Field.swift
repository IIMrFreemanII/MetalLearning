import SwiftUI
import Inject

struct Number1Field<T: SIMDScalar>: View {
  @ObserveInjection private var inject
  
  let label: String
  
  @Binding var value: T
  
  var body: some View {
    VStack(alignment: .leading, spacing: label.isEmpty ? 0 : 6) {
      Text(label)
      HStack {
        NumberField(value: $value)
      }
    }
    .enableInjection()
  }
}

struct Number1Field_Previews: PreviewProvider {
  static var previews: some View {
    Number1Field(label: "", value: .constant(0))
  }
}
