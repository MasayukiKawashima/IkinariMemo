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
  
  private var currentUserMemoViewModel: CurrentUserMemoViewModel
  private var realm: Realm

  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.currentUserMemoViewModel = currentUserMemoViewModel
    self.realm = try! Realm()

    // currentUserMemo の変化を監視
    self.cancellable = currentUserMemoViewModel.$currentUserMemo
      .sink { [weak self] newMemo in
        //テキストフィールドの入力内容確定後の新規メモ作成ボタン押下時のバグ回避のための処理
        //参考　https://dev.classmethod.jp/articles/swiftui-japanese-input-textfield-clear-button-issue/?utm_source=chatgpt.com
        
        if newMemo.title.isEmpty && !self!.title.isEmpty {
          let _ = self?.title.removeLast()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self?.title = ""
          }
        }
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
      currentUserMemoViewModel.currentUserMemo.title = title
      currentUserMemoViewModel.currentUserMemo.updatedAt = Date()
      realm.add(currentUserMemoViewModel.currentUserMemo, update: .modified)
    }
  }
}


