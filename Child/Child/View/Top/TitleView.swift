//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI
import RealmSwift

struct TitleView: View {
  @StateObject private var viewModel = TitleViewModel()
  @FocusState private var isTextFieldFocused: Bool

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: true) {
        TextField("タイトル", text: Binding(
          get: { viewModel.title },
          set: { viewModel.updateTitle($0) }
        ))
        .lineLimit(1)
        .font(.system(size: geometry.size.width * 0.074))
        .padding(.horizontal, geometry.size.width * 0.024)
        .focused($isTextFieldFocused)
        .onAppear {
          if viewModel.isFirstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              isTextFieldFocused = true
              viewModel.isFirstLaunch = false
            }
          }
        }
      }
    }
  }
}


#Preview {
      TitleView()
}
