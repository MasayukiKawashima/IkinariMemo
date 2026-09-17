//
//  WidgetSync.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/08/30.
//

import Foundation
import RealmSwift
import WidgetKit


// FIXME: - 将来的にWidgetの種類が増えた場合にWidgetSyncの再設計を検討
// 現状では最新メモWidget専用の設計になっているため、全てのWidgetに対応するように汎化を行うべきかも

enum WidgetSync {


  // MARK: - Methods

  /// 最新メモを共有 UserDefaults に書き出す。
  /// Realm への書き込みのたびに呼び、Widget が参照するデータを常に最新に保つ。
  static func updateSharedStore() {
    autoreleasepool {
      guard let realm = try? Realm() else {
        assertionFailure("Realm を開けませんでした")
        return
      }

      let latest = realm.objects(UserMemo.self)
        .sorted(byKeyPath: "updatedAt", ascending: false)
        .first

      SharedUserMemoStore.saveLatestMemo(latest.map {
        SharedUserMemo(id: $0.id.stringValue,
                       title: $0.title,
                       content: $0.content,
                       createdAt: $0.createdAt,
                       updatedAt: $0.updatedAt)
      })
    }
  }

  /// Widget のタイムラインを再読み込みさせる。
  /// reloadTimelines はシステム側で頻度制限があるため、
  /// 入力の1文字ごとではなく編集終了時や削除時などにまとめて呼ぶ。
  static func reloadWidget() {
    WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.latestMemo)
  }
}
