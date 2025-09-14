//
//  TopViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/10.
//

import Foundation
import Combine

// MARK: - Enums

enum FocusedField {
  case title
  case content
}

class TopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var isSideMenuOpen: Bool = false
  @Published var isKeyboardVisible: Bool = false
  private var currentUserMemoViewModel: CurrentUserMemoViewModel
  private var cancellable: AnyCancellable?
  
  // MARK: - Init
  
  init(currentUserMemoViewModel: CurrentUserMemoViewModel = .shared) {
    self.currentUserMemoViewModel = currentUserMemoViewModel

    // currentUserMemo の変化を監視
    self.cancellable = currentUserMemoViewModel.$currentUserMemo
      .sink { [weak self] newMemo in
      }
  }
  
  // MARK: - Methods
  
  func upDateCurrentUserMemo() {
    let newUserMemo: UserMemo = UserMemo()
    self.currentUserMemoViewModel.upDate(userMemo: newUserMemo)
  }
}
