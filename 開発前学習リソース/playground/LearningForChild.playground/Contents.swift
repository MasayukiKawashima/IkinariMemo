import SwiftUI
import PlaygroundSupport

class LearningForChildViewModel: ObservableObject {
  @Published var evenNum: [Int] = []

  func generateEvenNumbers() {
    evenNum = Array(1...10).filter { $0 % 2 == 0 }
  }
}

struct LearningForChildView: View {
  @StateObject var model: LearningForChildViewModel

  init(model: LearningForChildViewModel = LearningForChildViewModel()) {
    _model = StateObject(wrappedValue: model)
  }

  var body: some View {
    VStack(spacing: 20) {
      Text(model.evenNum.map { String($0) }.joined(separator: ", "))
      Button("偶数を表示") {
        model.generateEvenNumbers()
      }
    }
    .padding()
  }
}

PlaygroundPage.current.setLiveView(LearningForChildView())
