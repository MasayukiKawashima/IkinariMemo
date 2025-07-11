//
//  MemoListViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/11.
//

import Foundation

class MemoListViewModel: ObservableObject {
  
  @Published  var sideMenuMemoLists = (1...20).map { "メモ\($0)" }
}
