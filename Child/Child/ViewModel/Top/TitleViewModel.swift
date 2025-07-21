//
//  TitleViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import Foundation
import RealmSwift
import Combine

class TitleViewModel: ObservableObject {
  
  @Published var title: String = ""
  private var cancellable: AnyCancellable?
  
  private var currentMemoVM: CurrentUserMemoViewModel
  private var realm: Realm

  init(currentMemoVM: CurrentUserMemoViewModel = .shared) {
    self.currentMemoVM = currentMemoVM
    self.realm = try! Realm()

    // currentUserMemo の変化を監視
    self.cancellable = currentMemoVM.$currentUserMemo
      .sink { [weak self] newMemo in
        self?.title = newMemo.title
      }
  }

  func updateTitle(_ newTitle: String) {
    guard newTitle != title else { return }
    title = newTitle
    saveTitle()
  }

  private func saveTitle() {
    try? realm.write {
      currentMemoVM.currentUserMemo.title = title
      currentMemoVM.currentUserMemo.updatedAt = Date()
      realm.add(currentMemoVM.currentUserMemo, update: .modified)
    }
  }
}


