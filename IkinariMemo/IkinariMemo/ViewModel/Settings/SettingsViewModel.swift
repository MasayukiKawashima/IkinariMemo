//
//  SettingsViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/26.
//

import Foundation

class SettingsViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var appVersion: String
  @Published var year: String
  
  // MARK: - Init
  
  init () {
    self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let year = Calendar.current.component(.year, from: Date())
    self.year = String(year)
  }
}
