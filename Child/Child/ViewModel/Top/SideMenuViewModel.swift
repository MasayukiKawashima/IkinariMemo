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
    // 最新の8件のみを取得
    let allMemos = realm.objects(UserMemo.self).sorted(byKeyPath: "createdAt", ascending: false)

    if allMemos.count > 8 {
      // 8件以上ある場合は最新の8件のみ
      let limitedMemos = Array(allMemos.prefix(8))
      self.sideMenuMemoLists = realm.objects(UserMemo.self)
        .filter("SELF IN %@", limitedMemos)
        .sorted(byKeyPath: "createdAt", ascending: false)
    } else {
      // 8件以下の場合はそのまま
      self.sideMenuMemoLists = allMemos
    }
  }
  
  // MARK: - Methods
  
  func getTitlesFromSideMenuMemoLists() -> [String] {
    // 実際のメモからタイトルを取得し、配列に変換
    var titles = Array(sideMenuMemoLists.map { userMemo in
      return userMemo.title.isEmpty ? "タイトル未設定" : userMemo.title
    })
    
    // 8件に満たない場合は空文字で埋める
    while titles.count < 8 {
      titles.append("")
    }
    
    return titles
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

}
