//
//  UserMemoListItem.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/21.
//

import Foundation

class UserMemoListItem: Identifiable {

  // MARK: - Properties

  let id = UUID()
  let userMemo: UserMemo?
  let displayTitle: String
  let displayUpdatedDate: String

  // MARK: - Init

  init(userMemo: UserMemo) {
    self.userMemo = userMemo
    self.displayTitle = userMemo.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "タイトル未設定" : userMemo.title

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    displayUpdatedDate = formatter.string(from: userMemo.updatedAt)
  }
}
