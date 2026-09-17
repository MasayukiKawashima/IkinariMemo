//
//  MemoListViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/11.
//

import Foundation
import RealmSwift
import Combine

class MemoListViewModel: ObservableObject {


  // MARK: - Properties

  @Published  var memoLists: Results<UserMemo>
  private let repository: MemoRepositoryProtocol
  private var token: NotificationToken?


  // MARK: - Init

  init(repository: MemoRepositoryProtocol = MemoRepository()) {
    self.repository = repository
    memoLists = repository.fetchAllSortedByCreatedAt()

    observeMemos()
  }


  // MARK: - Methods

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

  private func observeMemos() {
    token = repository.observeAll { [weak self] in
      guard let self = self else { return }

      // データが0件になった場合のみ、プレースホルダー表示へ切り替えるため再描画する。
      // 残件がある削除は List のスワイプアニメーションが追随するため再描画しない。
      if self.memoLists.isEmpty {
        DispatchQueue.main.async {
          self.memoLists = self.repository.fetchAllSortedByCreatedAt()
        }
      }
    }
  }

  func getDisplayItems() -> [UserMemoListItem] {
    var items: [UserMemoListItem] = []

    for userMemo in self.memoLists {
      items.append(UserMemoListItem(userMemo: userMemo))
    }
    return items
  }

  func selectMemo(_ item: UserMemoListItem) {
    guard let userMemo = item.userMemo else { return }
    CurrentUserMemoViewModel.shared.upDate(userMemo: userMemo)
  }

  func hasAnyUserMemo() -> Bool {
    // 一件でもある場合 true、ない場合は false
    repository.hasAnyMemo()
  }

}
