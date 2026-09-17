//
//  DisplayedMemoUpdaterForWidgetLink.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/10.
//

import Foundation

final class DisplayedMemoUpdaterForWidgetLink {


  // MARK: - DisplayTargetUpdate

  enum DisplayTargetUpdate {

    /// 表示対象を Widget のメモへ更新した(currentUserMemoViewModelの更新）
    case updated

    /// 表示対象は更新しなかった
    case notUpdated
  }


  // MARK: - Properties

  private let repository: MemoRepositoryProtocol
  private let currentUserMemoViewModel: CurrentUserMemoViewModel


  // MARK: - Init

  init(repository: MemoRepositoryProtocol = MemoRepository(),
       currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.repository = repository
    self.currentUserMemoViewModel = currentUserMemoViewModel
  }


  // MARK: - Methods

  /// 受け取った URL を表示対象へ反映する
  func updateDisplayTarget(from url: URL) -> DisplayTargetUpdate {

    switch MemoDeepLink.displayTarget(from: url) {

    case .memo(let id):
      // メモが見つからない場合（Widget のスナップショットが古く、既に削除済みなど）は
      // 何もせず、通常起動と同じ状態のままにする
      guard let memo = repository.fetch(id: id) else { return .notUpdated }
      currentUserMemoViewModel.upDate(userMemo: memo)
      return .updated

    case .newMemo:
      // 新規メモの用意は CurrentUserMemoViewModel の初期化が担うため何もしない
      // 常駐中のタップで編集中のメモを消さないために意図的に何もしないようにしている
      return .notUpdated
    }
  }
}
