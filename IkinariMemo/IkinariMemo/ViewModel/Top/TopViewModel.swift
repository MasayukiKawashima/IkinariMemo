//
//  TopViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/10.
//

import Foundation
import Combine


// MARK: - Enums

enum FocusedField {
  case title
  case content
}

class TopViewModel: ObservableObject {


  // MARK: - Properties

  @Published var isSideMenuOpen: Bool = false
  @Published var isKeyboardVisible: Bool = false
  private var currentUserMemoViewModel: CurrentUserMemoViewModel
  private let repository: MemoRepositoryProtocol
//  private var cancellable: AnyCancellable?


  // MARK: - Init

  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared,
       repository: MemoRepositoryProtocol = MemoRepository()) {
    self.currentUserMemoViewModel = currentUserMemoViewModel
    self.repository = repository

    // currentUserMemo の変化を監視
//    self.cancellable = currentUserMemoViewModel.$currentUserMemo
//      .sink { [weak self] newMemo in
//      }
  }


  // MARK: - Methods

  func upDateCurrentUserMemo() {
    let newUserMemo: UserMemo = UserMemo()
    self.currentUserMemoViewModel.upDate(userMemo: newUserMemo)
  }

  /// 編集終了（キーボード非表示）時に Widget のタイムラインを更新する
  func onEditingEnded() {
    repository.reloadWidgetTimeline()
  }
}
