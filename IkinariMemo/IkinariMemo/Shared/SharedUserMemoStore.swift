//
//  SharedUserMemoStore.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/08/26.
//

import Foundation
import WidgetKit

enum SharedUserMemoStore {


  // MARK: - Properties

  static let appGroupID = "group.dev.kawashima.IkinariMemo"
  private static let latestMemoKey = "latestMemo"
  private static var userDefaults: UserDefaults? {
    UserDefaults(suiteName: appGroupID)
  }
  private static let titleLimit = 100
  private static let contentLimit = 500


  // MARK: - 保存 本体側からのみ利用

  /// 内容に変化があった場合のみ保存し、Widget のタイムラインを更新する
  static func saveLatestMemo(_ memo: SharedUserMemo?) {
    guard let userDefaults else {
      assertionFailure("App Group が設定されていません: \(appGroupID)")
      return
    }

    // 比較の前に切り詰める
    // 保存される値は切り詰め済みのため、未切り詰めのまま比較すると
    // 長いメモで常に「差分あり」となり差分ゲートが機能しなくなる
    let newValue = memo.map {
      trimmed($0)
    }

    // 差分比較を行う
    // 起動やフォアグラウンド復帰のたびに呼ばれても、
    // 内容が変わっていなければ書き込みも reload も行わない
    guard loadLatestMemo() != newValue else { return }

    // メモが一件もなかった場合にWidget側に共有するメモも削除する
    // 例えば全メモ削除後、本体側ではメモが一件もないのに、widget側で表示されてしまうことを防ぐための処理
    guard let newValue else {
      userDefaults.removeObject(forKey: latestMemoKey)
      reloadWidget()
      return
    }

    do {
      let data = try JSONEncoder().encode(newValue)
      userDefaults.set(data, forKey: latestMemoKey)
      reloadWidget()   // 🆕 追加: 保存に成功したときだけ更新する
    } catch {
      assertionFailure("SharedUserMemo のエンコードに失敗: \(error)")
    }
  }


  // MARK: - 読み込み

  static func loadLatestMemo() -> SharedUserMemo? {
    guard let data = userDefaults?.data(forKey: latestMemoKey) else { return nil }
    return try? JSONDecoder().decode(SharedUserMemo.self, from: data)
  }


  // MARK: - Widget 更新

  /// 他の箇所から直接呼ばないことで「差分がないのに reload される」事故を防ぐ
  private static func reloadWidget() {
    WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.latestMemo)
  }


  // MARK: - 文字数切り詰め

  /// ウィジェットの表示に必要な長さだけを残す
  private static func trimmed(_ memo: SharedUserMemo) -> SharedUserMemo {
    SharedUserMemo(
      id: memo.id,
      title: String(memo.title.prefix(titleLimit)),
      content: String(memo.content.prefix(contentLimit)),
      createdAt: memo.createdAt,
      updatedAt: memo.updatedAt
    )
  }
}
