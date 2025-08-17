//
//  SideMenuViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/09.
//

import Foundation
import SwiftUI
import RealmSwift

class SideMenuViewModel: ObservableObject {
  
  // MARK: - Properties
  @Published var sideMenuMemoLists: Results<UserMemo>
  let realm: Realm
  
  init() {
    self.realm = try! Realm()
    self.sideMenuMemoLists = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)
    reloadSideMenuMemoLists()
  }
  
  // MARK: - Methods
  
  /// 最新の最大8件を再取得する
  private func reloadSideMenuMemoLists() {
    let allMemos = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)
    
    if allMemos.count > 8 {
      let limitedMemosArray = Array(allMemos.prefix(8))
      let ids = limitedMemosArray.map { $0.id }
      self.sideMenuMemoLists = realm.objects(UserMemo.self)
        .filter("id IN %@", ids)
        .sorted(byKeyPath: "createdAt", ascending: false)
    } else {
      self.sideMenuMemoLists = allMemos
    }
    // Published 更新を反映させる
    objectWillChange.send()
  }
  
  func getDisplayItems() -> [UserMemoListItem] {
    var items: [UserMemoListItem] = []
    for userMemo in self.sideMenuMemoLists {
      items.append(UserMemoListItem(userMemo: userMemo))
    }
    while items.count < 8 {
      items.append(UserMemoListItem(userMemo: nil))
    }
    return items
  }
  
  func selectMemo(_ item: UserMemoListItem) {
    guard let userMemo = item.userMemo else { return }
    CurrentUserMemoViewModel.shared.upDate(userMemo: userMemo)
  }
  
  func deleteItems(at offsets: IndexSet) {
    let items = getDisplayItems()
    
    for index in offsets {
      let item = items[index]
      if let userMemo = item.userMemo {
        do {
          try realm.write {
            realm.delete(userMemo)
          }
        } catch {
          print("削除エラー: \(error.localizedDescription)")
        }
      }
    }
    // 🔴 削除後に再取得して8件に揃える
    reloadSideMenuMemoLists()
  }
}
