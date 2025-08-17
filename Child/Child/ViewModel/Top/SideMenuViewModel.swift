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
    
    let allMemos = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)

    if allMemos.count > 8 {
      //すべてのメモから最新8件を取得
      let limitedMemosArray = Array(allMemos.prefix(8))
      //最新8件のidを取得
      let ids = limitedMemosArray.map { $0.id }
      //それらのidを使って、同じidのRealmオブジェクトを再取得
      //取得する際に作成日時にでソートして、新しいメモが上に表示されるようにする
      self.sideMenuMemoLists = realm.objects(UserMemo.self)
        .filter("id IN %@", ids)
        .sorted(byKeyPath: "createdAt", ascending: false)
    } else {
      self.sideMenuMemoLists = allMemos
    }
  }
  
  // MARK: - Methods
  
//  func getTitlesFromSideMenuMemoLists() -> [String] {
//    // 実際のメモからタイトルを取得し、配列に変換
//    var titles = Array(sideMenuMemoLists.map { userMemo in
//      return userMemo.title.isEmpty ? "タイトル未設定" : userMemo.title
//    })
//    
//    // 8件に満たない場合は空文字で埋める
//    while titles.count < 8 {
//      titles.append("")
//    }
//    
//    return titles
//  }
  
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
  }


}
