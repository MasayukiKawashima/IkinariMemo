//
//　アプリの起動処理を定義するファイル
//　AppDelegate的な役割
//  IkinariMemoApp.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/01.
//

import SwiftUI
import GoogleMobileAds

@main
struct IkinariMemoApp: App {


  // MARK: - Properties

  @Environment(\.scenePhase) private var scenePhase


  // MARK: - Init

  init() {

    // Realmと共有UserDefaultsの同期のための処理
    LatestMemoSynchronizer.shared.start()
    // バナー広告処理
    MobileAds.shared.start()
  }

  
  // MARK: - Body

  var body: some Scene {
    WindowGroup {
      TopView().environmentObject(CurrentUserMemoViewModel.shared)
      // 何らかの理由によりRealm変更の購読が行われなかった場合の保険処理
      // アプリがフォアグラウンドに復帰した時に購読がされているかをチェックし、未購読なら購読処理を行う
        .onChange(of: scenePhase) { _, newPhase in
          if newPhase == .active {
            LatestMemoSynchronizer.shared.refreshNow()
          }
        }
        }
    }
}
