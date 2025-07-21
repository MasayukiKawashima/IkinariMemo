//
//  UserMemoListItem.swift
//  Child
//
//  Created by 川島真之 on 2025/07/21.
//

import Foundation

class UserMemoListItem: Identifiable {
  
  let id = UUID()
  let userMemo: UserMemo?
  let displayTitle: String
  let isEmpty: Bool
  
  init(userMemo: UserMemo?) {
    self.userMemo = userMemo
    
    if let userMemo = userMemo {
      self.displayTitle = userMemo.title.isEmpty ? "タイトル未設定" : userMemo.title
      self.isEmpty = false
      
    } else {
      self.displayTitle = ""
      self.isEmpty = true
    }
  }
}
