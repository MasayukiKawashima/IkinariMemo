//
//  TitleViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import Foundation
import RealmSwift

class TitleViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var title: String = "" {
    didSet {
      // 前回と同じ値ならスキップ
      guard title != oldValue else { return } 
      saveTitle()
    }
  }
  
  private var userMemo: UserMemo?
  private var realm: Realm
  
  // MARK: - Init
  
  init() {
    realm = try! Realm()
//    loadTitle()
    let result = realm.objects(UserMemo.self)
    print(result)
  }
  
  // MARK: - Methods
  
  private func loadTitle() {
    // （仮）最初の1件を取得
    if let savedMemo = realm.objects(UserMemo.self).first {
      self.userMemo = savedMemo
      self.title = savedMemo.title
    }
  }
  
  private func saveTitle() {
    // memoがある場合はタイトル更新、なければ新規作成
    if let userMemo = userMemo {
      try? realm.write {
        userMemo.title = title
      }
    } else
    {
      let newMemo = UserMemo()
      newMemo.title = title
      try? realm.write {
        realm.add(newMemo)
      }
      self.userMemo = newMemo
    }
  }
}
