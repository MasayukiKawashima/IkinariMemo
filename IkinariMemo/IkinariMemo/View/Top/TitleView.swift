//
//  TitleView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI
import RealmSwift

struct TitleView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel = TitleViewModel()
  var focusedField: FocusState<FocusedField?>.Binding
  
  private let textFieldFontSizeRatio: CGFloat = 0.07
  private let textFieldPaddingHorizontalRatio: CGFloat = 0.03
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: true) {
        ZStack {
          
          Color.clear
            .contentShape(Rectangle())
            .frame(width: geometry.size.width, height: geometry.size.height)// タップ判定を全体に
            .onTapGesture {
              focusedField.wrappedValue = .title
            }
          
          TextField("タイトル", text: Binding(
            get: { viewModel.title },
            set: { viewModel.updateTitle($0) }
          ))

          .padding(.horizontal, geometry.size.width * textFieldPaddingHorizontalRatio)
          .lineLimit(1)
          .font(.system(size: geometry.size.width * textFieldFontSizeRatio))
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
}

