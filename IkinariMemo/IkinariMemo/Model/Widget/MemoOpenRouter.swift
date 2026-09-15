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
  ///  - Returns: メモがあった場合は true、ない場合はfalseを変えす
  ///  これらの値は呼び出し側がトップ画面への復帰の判断に利用する
  ///
  @discardableResult
  func handle(_ url: URL) -> Bool {

    switch MemoDeepLink.displayTarget(from: url) {
    case .memo(let id):
      return openMemo(id: id)

    case .newMemo:
      // 新規メモの用意は CurrentUserMemoViewModel の初期化が担うため何もしない
      return false
    }
  }

  /// id に一致するメモを Realm から取得して表示対象にする
  /// 見つからない場合（Widget のスナップショットが古く、既に削除済みなど）は
  /// falseを返し、その他には何も処理しない
  private func openMemo(id: String) -> Bool {
    // スナップショットが古く既に削除済みの場合は何もしない
    guard let memo = repository.fetch(id: id) else { return false }
    currentUserMemoViewModel.upDate(userMemo: memo)
    return true
  }
}
