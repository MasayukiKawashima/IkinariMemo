//
//  DeleteDataViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/12.
//

import Foundation

class DeleteDataViewModel: ObservableObject {


  // MARK: - Properties

  private var currentUserMemoViewModel: CurrentUserMemoViewModel
  private let repository: MemoRepositoryProtocol


  // MARK: - Init

  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared,
       repository: MemoRepositoryProtocol = MemoRepository()) {
    self.currentUserMemoViewModel = currentUserMemoViewModel
    self.repository = repository
  }

  
  // MARK: - Methods

  func deleteAllMemos() {
    // 全てのMemoを削除（Widget / 共有 UserDefaults への同期は Repository 内で実施）
    repository.deleteAll()
    let newMemo = UserMemo()
    currentUserMemoViewModel.upDate(userMemo: newMemo)
  }
}
