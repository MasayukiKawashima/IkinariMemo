//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI
import RealmSwift

struct TitleView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel = TitleViewModel()
  var focusedField: FocusState<TopView.FocusedField?>.Binding
  
  private let textFieldFontSizeRatio: CGFloat = 0.074
  private let textFieldPaddingHorizontalRatio: CGFloat = 0.024
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: true) {
        TextField("タイトル", text: Binding(
          get: { viewModel.title },
          set: { viewModel.updateTitle($0) }
        ))
        .lineLimit(1)
        .font(.system(size: geometry.size.width * textFieldFontSizeRatio))
        .padding(.horizontal, geometry.size.width * textFieldPaddingHorizontalRatio)
        .focused(focusedField, equals: .title)
        .onAppear {
          if viewModel.isFirstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              focusedField.wrappedValue = .title
              viewModel.isFirstLaunch = false
            }
          }
        }
      }
    }
  }
}

