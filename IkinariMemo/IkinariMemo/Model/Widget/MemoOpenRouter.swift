//
//  MemoOpenRouter.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/10.
//

import Foundation

@MainActor
final class MemoOpenRouter {


  // MARK: - DisplayTargetUpdate

  /// URL から得た DisplayTarget を表示対象へ反映した結果
  /// 反映しなかった理由（新規メモ指定／対象が削除済み）は
  /// どちらも「表示対象は元のまま」に帰着するため区別しない
  enum DisplayTargetUpdate {

    /// 表示対象を Widget のメモへ更新した(currentUserMemoViewModelの更新）
    case updated

    /// 表示対象は更新しなかった
    case notUpdated
  }


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

  /// 受け取った URL を表示対象へ反映する

  func updateDisplayTarget(from url: URL) -> DisplayTargetUpdate {

      switch MemoDeepLink.displayTarget(from: url) {
      case .memo(let id):
        return updateDisplayTarget(memoID: id)

      case .newMemo:
        // 新規メモの用意は CurrentUserMemoViewModel の初期化が担うため何もしない
        // 常駐中のタップで編集中のメモを消さないために意図的に何もしないようにしている
        return .notUpdated
      }
    }

  /// id に一致するメモを Realm から取得して表示対象にする
    /// 見つからない場合（Widget のスナップショットが古く、既に削除済みなど）は
    /// 何もせず、通常起動と同じ状態のままにする
    private func updateDisplayTarget(memoID: String) -> DisplayTargetUpdate {
      guard let memo = repository.fetch(id: memoID) else { return .notUpdated }
      currentUserMemoViewModel.upDate(userMemo: memo)
      return .updated
    }
}
