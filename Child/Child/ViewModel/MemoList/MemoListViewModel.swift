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
  private var token: NotificationToken?
  // MARK: - Init
  
  init() {
    self.realm = try! Realm()
    memoLists = realm.objects(UserMemo.self).sorted(byKeyPath: "createdAt", ascending: false)
    
    observeMemos()
  }
  
  // MARK: - Methods
  
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
  
  private func observeMemos() {
    let allMemos = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)
    
    token = allMemos.observe { [weak self] changes in
      guard let self = self else { return }
      
      switch changes {
      case .initial:
        // 初期データの読み込み時（再描画しない）
        break
        
      case .update:
        // データに変更があった時
        // データが0件になった場合のみ処理
        if allMemos.isEmpty {
          DispatchQueue.main.async {
            // 画面を再描画するための処理
            self.memoLists = allMemos
          }
        }
        
      case .error(let error):
        // エラーハンドリング
        print("Realm監視エラー: \(error.localizedDescription)")
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
    do {
      let realm = try Realm()
      let results = realm.objects(UserMemo.self)
      // !results.isEmptyとすることで、一件でもある場合true、ない場合はfalse
      return !results.isEmpty
    } catch {
      print("Realmの初期化に失敗しました: \(error)")
      return false
    }
  }
  
}
