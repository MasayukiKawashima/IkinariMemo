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
  
  init(currentUserMemo: UserMemo) {
    self.currentUserMemo = currentUserMemo
    self.title = currentUserMemo.title
    self.realm = try! Realm()
  }
  
  private func saveTitle() {
    try? realm.write {
      currentUserMemo.title = title
    }
  }
}

