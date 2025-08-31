//
//  MemoListViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/11.
//

import Foundation
import RealmSwift
import Combine

class MemoListViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published  var memoLists: Results<UserMemo>
  let realm: Realm
  // MARK: - Init
  
  init() {
    self.realm = try! Realm()
    memoLists = realm.objects(UserMemo.self).sorted(byKeyPath: "createdAt", ascending: false)
    
  }
  
  // MARK: - Methods
  
//  func getTitlesFromAllMemoLists() -> [String] {
//    // 実際のメモからタイトルを取得し、配列に変換
//    let titles = Array(memoLists.map { userMemo in
//      return userMemo.title.isEmpty ? "タイトル未設定" : userMemo.title
//    })
//    return titles
//  }
  
  func deleteItems(at offsets: IndexSet) {
    let items = getDisplayItems()
    
    for index in offsets {
      let item = items[index]
      
      if let userMemo = item.userMemo {
        //削除するメモが現在表示中のメモだったら
        if userMemo.id == CurrentUserMemoViewModel.shared.currentUserMemo.id {
          //新しいメモをセットする
          let newMemo = UserMemo()
          CurrentUserMemoViewModel.shared.upDate(userMemo: newMemo)
        }
        
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

}
