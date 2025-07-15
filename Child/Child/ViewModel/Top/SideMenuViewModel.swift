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
  
  @Published  var sideMenuMemoLists = (1...8).map { "メモあああああああああああああああああああああああああああああああああああああああああ\($0)" }
  
}
