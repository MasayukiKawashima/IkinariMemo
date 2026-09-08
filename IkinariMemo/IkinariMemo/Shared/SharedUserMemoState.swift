//
//  SharedUserMemoState.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/08.
//

import Foundation

enum SharedUserMemoState: Codable, Equatable {

  case memo(SharedUserMemo)
  case noMemos
}
