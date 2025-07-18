//
//  ContentViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import Foundation
import RealmSwift

class ContentViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var textContent: String = "" {
    didSet {
      guard textContent != oldValue else { return }
      saveContent()
    }
  }

  private var currentUserMemo: UserMemo
  private var realm: Realm
  
  // MARK: - Init
  
  init() {
    self.currentUserMemo = CurrentUserMemoManager.shared.currentUserMemo
    self.textContent = currentUserMemo.content
    self.realm = try! Realm()
  }

  private func saveContent() {
    try? realm.write {
      currentUserMemo.content = textContent
    }
  }
}
