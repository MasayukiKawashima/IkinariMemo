//
//  CurrentUserMemoViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/18.
//

import Foundation
import RealmSwift


// MARK: - CurrentUserMemoViewModelProtocol

protocol CurrentUserMemoViewModelProtocol {

  func upDate(userMemo: UserMemo)
}


// MARK: - CurrentUserMemoViewModel

final class CurrentUserMemoViewModel: ObservableObject, CurrentUserMemoViewModelProtocol {


  // MARK: - Properties

  // シングルトンとして定義
  static let shared: CurrentUserMemoViewModel = .init()
  @Published  var currentUserMemo: UserMemo


  // MARK: - Init

  private init() {
    currentUserMemo = UserMemo()
  }

  
  // MARK: - Methods

  func upDate(userMemo: UserMemo) {
    self.currentUserMemo = userMemo
  }
}
