//
//  SideMenuViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/09.
//

import Foundation
import SwiftUI
import RealmSwift

class SideMenuViewModel: ObservableObject {


  // MARK: - Properties

  @Published var sideMenuMemoLists: [UserMemo] = []
  private var token: NotificationToken?
  private let repository: MemoRepositoryProtocol


  // MARK: - Init

  init(repository: MemoRepositoryProtocol = MemoRepository()) {
    self.repository = repository
    observeMemos()
  }

  
  // MARK: - Methods

  private func observeMemos() {
    token = repository.observeAll { [weak self] in
      self?.reloadSideMenuMemoLists()
    }

    reloadSideMenuMemoLists()
  }

  // 最新の最大8件を再取得する
  func reloadSideMenuMemoLists() {
    let allMemos = repository.fetchAllSortedByCreatedAt()

    if allMemos.count > 8 {
      self.sideMenuMemoLists = Array(allMemos.prefix(8))
    } else {
      self.sideMenuMemoLists = Array(allMemos)
    }
  }

  func getDisplayItems() -> [UserMemoListItem] {
    var items: [UserMemoListItem] = []

    for userMemo in self.sideMenuMemoLists {
      items.append(UserMemoListItem(userMemo: userMemo))
    }
    return items
  }

  // メモタップ時にCurrentUserMemoを更新する
  func selectMemo(_ item: UserMemoListItem) {
    guard let userMemo = item.userMemo else { return }
    CurrentUserMemoViewModel.shared.upDate(userMemo: userMemo)
  }

  func deleteItems(at offsets: IndexSet) {
    let items = getDisplayItems()

    for index in offsets {
      let item = items[index]

      if let userMemo = item.userMemo {
        // 削除するメモが現在表示中のメモだったら
        if userMemo.id == CurrentUserMemoViewModel.shared.currentUserMemo.id {
          // 新しいメモをセットする
          let newMemo = UserMemo()
          CurrentUserMemoViewModel.shared.upDate(userMemo: newMemo)
        }

        repository.delete(userMemo)
      }
    }
  }

  // メモが一件もない場合にプレスホルダーViewを表示するための判定メソッド
  func hasAnyUserMemo() -> Bool {
    // 一件でもある場合 true、ない場合は false
    repository.hasAnyMemo()
  }

}
