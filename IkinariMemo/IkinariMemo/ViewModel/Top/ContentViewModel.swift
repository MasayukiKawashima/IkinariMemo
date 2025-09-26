//
//  ContentViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/07.
//

import Foundation
import RealmSwift
import Combine

class ContentViewModel: ObservableObject {

  // MARK: - Properties

  @Published var textContent: String = ""
  private var cancellable: AnyCancellable?

  private var currentUserMemoViewModel: CurrentUserMemoViewModel
  private var realm: Realm

  // MARK: - Init

  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.currentUserMemoViewModel = currentUserMemoViewModel
    self.realm = try! Realm()

    // currentUserMemo の変化を監視
    self.cancellable = currentUserMemoViewModel.$currentUserMemo
      .sink { [weak self] newMemo in
        self?.textContent = newMemo.content
      }
  }

  // MARK: - Methods

  func updateContent(_ newContent: String) {
    guard newContent != textContent else { return }
    textContent = newContent
    saveContent()
  }

  private func saveContent() {
    try? realm.write {
      currentUserMemoViewModel.currentUserMemo.content = textContent
      currentUserMemoViewModel.currentUserMemo.updatedAt = Date()
      realm.add(currentUserMemoViewModel.currentUserMemo, update: .modified)
    }
  }
}
