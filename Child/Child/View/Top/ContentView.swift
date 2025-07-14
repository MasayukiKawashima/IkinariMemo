//
//  ContentView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
  
  @ObservedRealmObject var currentUserMemo: UserMemo
  @StateObject private var viewModel: ContentViewModel
  
  init(currentUserMemo: UserMemo) {
    _viewModel = StateObject(wrappedValue: ContentViewModel(currentUserMemo: currentUserMemo))
    self.currentUserMemo = currentUserMemo
  }
  
  private let TextEditorSidePaddingRatio: CGFloat = 0.024
  
  var body: some View {
    GeometryReader { geometry in
      TextEditor(text: $viewModel.textContent)
        .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
    }
  }
}


#Preview {
  let previewData = UserMemo()
  ContentView(currentUserMemo: previewData)
}
