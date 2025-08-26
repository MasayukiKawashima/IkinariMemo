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
  @Published var sideMenuMemoLists: [UserMemo] = []
    private var token: NotificationToken?
    let realm: Realm
  
  // MARK: - Init

    init() {
      self.realm = try! Realm()
      observeMemos()
    }
  
  // MARK: - Methods
  
  private func observeMemos() {
    let allMemos = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)
    
    token = allMemos.observe { [weak self] _ in
      self?.reloadSideMenuMemoLists()
    }
    
    reloadSideMenuMemoLists()
  }
  
  // 最新の最大8件を再取得する
  func reloadSideMenuMemoLists() {
    let allMemos = realm.objects(UserMemo.self)
      .sorted(byKeyPath: "createdAt", ascending: false)
    
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
  
  //メモタップ時にCurrentUserMemoを更新する
  func selectMemo(_ item: UserMemoListItem) {
    guard let userMemo = item.userMemo else { return }
    CurrentUserMemoViewModel.shared.upDate(userMemo: userMemo)
  }
  
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
    reloadSideMenuMemoLists()
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


