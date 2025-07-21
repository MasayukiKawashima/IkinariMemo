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
      guard title != oldValue else { return }
      saveTitle()
    }
  }
  
  private var currentUserMemo: UserMemo
  private var realm: Realm
  
  // MARK: - Init
  
  init() {
    self.currentUserMemo = CurrentUserMemoViewModel.shared.currentUserMemo
    self.title = currentUserMemo.title
    self.realm = try! Realm()
  }
  
  private func saveTitle() {
    try? realm.write {
      // currentUserMemoのIDでRealmから既存のオブジェクトを検索
      if let existingMemo = realm.object(ofType: UserMemo.self, forPrimaryKey: currentUserMemo.id) {
        // 既存のオブジェクトが存在する場合、上書き
        existingMemo.title = title
        existingMemo.updatedAt = Date()
      } else {
        // 存在しない場合、新しいオブジェクトとして追加
        currentUserMemo.title = title
        //ユーザーにとってはメモを新規作成するの実質この段階なためcreatedAtを再設定
        currentUserMemo.createdAt = Date()
        currentUserMemo.updatedAt = Date()
        realm.add(currentUserMemo)
      }
    }
  }
}

