//
//　アプリの起動処理を定義するファイル
//　AppDelegate的な役割
//  ChildApp.swift
//  Child
//
//  Created by 川島真之 on 2025/07/01.
//

import SwiftUI
import GoogleMobileAds

@main
struct ChildApp: App {
  
  // MARK: - Init
  
  init() {
    MobileAds.shared.start()
  }
  
  // MARK: - Body
    var body: some Scene {
        WindowGroup {
          TopView().environmentObject(CurrentUserMemoViewModel.shared)
        }
    }
}

