
import SwiftUI
import Foundation
import PlaygroundSupport
import Combine

// MARK: Model
class Model {
  
}


// MARK: View
struct LeariningForChild2View: View {
  
  @StateObject var viewModel = ViewModel()
  
  var body: some View {
    TextEditor(text: $viewModel.text)
      .frame(width: 300, height: 300)
      .border(Color.blue)
    
    Text("文字数: \(viewModel.count)")
    
    if viewModel.isOverLimit {
      Text("文字数が１００文字を超えました")
        .foregroundStyle(.red)
    }
    Spacer()
  }
}

// MARK: ViewModel
class ViewModel: ObservableObject {
  
  @Published var text: String = ""
  @Published var count: Int = 0
  @Published var isOverLimit = false
  
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    $text
      .map { $0.count }
      .handleEvents(receiveOutput: {[weak self] count in
        self?.isOverLimit = count > 100
      })
      .assign(to: \.count, on: self)
      .store(in: &cancellables)
  }
  
}

// MARK: Live

PlaygroundPage.current.setLiveView(LeariningForChild2View())
