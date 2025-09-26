//
//  DeleteDataViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/12.
//

import Foundation
import RealmSwift

class DeleteDataViewModel: ObservableObject {

  // MARK: - Properties

  private var currentUserMemoViewModel: CurrentUserMemoViewModel

  // MARK: - Init

  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.currentUserMemoViewModel = currentUserMemoViewModel
  }

  // MARK: - Methods

  func deleteAllMemos() {
    do {
      let realm = try Realm()
      let allMemos = realm.objects(UserMemo.self)

      try realm.write {
        // 全てのMemoを削除
        realm.delete(allMemos)
      }
      let newMemo = UserMemo()
      currentUserMemoViewModel.upDate(userMemo: newMemo)
    } catch {
      print("Realmの全てのメモの削除処理でエラーが発生しました: \(error.localizedDescription)")
    }
  }
}
