//
//  MemoOpenRouter.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/10.
//

import Foundation

@MainActor
final class MemoOpenRouter {


  // MARK: - Properties

  static let shared = MemoOpenRouter()

  private let repository: MemoRepositoryProtocol
  private let currentUserMemoViewModel: CurrentUserMemoViewModel


  // MARK: - Init

  init(repository: MemoRepositoryProtocol = MemoRepository.shared,
       currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.repository = repository
    self.currentUserMemoViewModel = currentUserMemoViewModel
  }


  // MARK: - Methods

  /// 受け取った URL を処理する
  func handle(_ url: URL) {

    switch MemoDeepLink.displayTarget(from: url) {
    case .memo(let id):
      openMemo(id: id)

    case .newMemo:
      // 新規メモの用意は CurrentUserMemoViewModel の初期化が担うため何もしない
      // 常駐中のタップで編集中のメモを消さないために意図的に何もしないようにしている
      break
    }
  }

  /// id に一致するメモを Realm から取得して表示対象にする
  /// 見つからない場合（Widget のスナップショットが古く、既に削除済みなど）は
  /// 何もせず、通常起動と同じ状態のままにする
  private func openMemo(id: String) {
    guard let memo = repository.fetch(id: id) else { return }
    currentUserMemoViewModel.upDate(userMemo: memo)
  }
}
