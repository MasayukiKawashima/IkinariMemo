//
//  TopViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/10.
//

import Foundation

class TopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var isSideMenuOpen: Bool = false
  @Published var currentUserMemo: UserMemo
  
  // MARK: - Init
  
  init (currentUserMemo: UserMemo? = nil) {
    //UserMemoが渡されてきた時はそれを現在の保持
    if let currentUserMemo = currentUserMemo {
      self.currentUserMemo = currentUserMemo
    } else {
      //currentUserMemo引数がnilだったら新しいUserMemoを作成
      //新しいUserMemoをつくるだけ。Realmにはまだ保存しない
      let newMemo = UserMemo()
      newMemo.title = "成功！"
      newMemo.content = "UserMemoの伝搬フロー成功"
      self.currentUserMemo = newMemo
    }
  }
}
