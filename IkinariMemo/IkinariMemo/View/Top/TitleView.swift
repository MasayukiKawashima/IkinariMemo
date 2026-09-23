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
          .task {
            guard viewModel.isFirstLaunch else { return }
            viewModel.isFirstLaunch = false

            // キーボードツールバーの登録が完了するまで待つ
            try? await Task.sleep(for: .milliseconds(500))

            // 待機中に画面が閉じられた場合は何もしない
            guard !Task.isCancelled else { return }

            let memo = CurrentUserMemoViewModel.shared.currentUserMemo
            // 空の新規メモのときだけ自動フォーカスする
            // Widget から既存メモを開いた場合はキーボードを出さない
            if memo.title.isEmpty && memo.content.isEmpty {
              focusedField.wrappedValue = .title
            }
          }
        }
      }
    }
  }
}
