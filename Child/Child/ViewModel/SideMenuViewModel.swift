//
//  SideMenuViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/07/09.
//

import Foundation
import SwiftUI

class SideMenuViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published  var sideMenuMemoLists = ["メモ１", "メモ２", "メモ3", "メモ4", "メモ5", "メモ6", "メモ7", "メモ8"]
  
}
