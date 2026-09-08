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
  /// 引数は従来どおり Optional を受け取り、SharedUserMemoState への変換は内部で行う
  /// 呼び出し側が .noMemos を明示的に渡す必要はない
  static func saveLatestMemo(_ memo: SharedUserMemo?) {
    guard let userDefaults else {
      assertionFailure("App Group が設定されていません: \(appGroupID)")
      return
    }

    // SharedUserMemo?をSharedUserMemoState へ変換する
    // 比較の前に切り詰めること
    // 保存される値は切り詰め済みのため、未切り詰めのまま比較すると
    // 長いメモで常に「差分あり」となり差分ゲートが機能しなくなる
    // memoがnilの場合は.noMemosが代入される
    let newState: SharedUserMemoState = memo.map { .memo(trimmed($0)) } ?? .noMemos

    // 差分ゲート
    // 起動やフォアグラウンド復帰のたびに呼ばれても、
    // 内容が変わっていなければ書き込みも reload も行わない
    guard loadLatestMemoState() != newState else { return }

    // メモ0件でもキーを削除せず .noMemos を保存する
    // キーの有無が「同期したか否か」を表すようになるため、
    // 削除してしまうと未同期と区別できなくなる
    do {
      let data = try JSONEncoder().encode(newState)
      userDefaults.set(data, forKey: latestMemoKey)
      reloadWidget()
    } catch {
      assertionFailure("SharedUserMemoState のエンコードに失敗: \(error)")
    }
  }


  // MARK: - 読み込み Widget側と差分ゲートから利用

  /// 共有UserDefaultsに保存された状態を返す
  ///
  /// - Returns: nil はアプリ本体がまだ一度も同期していないことを意味する
  ///            この nil を「未同期」と解釈するのは LatestMemoProvider の役割


  static func loadLatestMemoState() -> SharedUserMemoState? {
    guard let data = userDefaults?.data(forKey: latestMemoKey) else { return nil }
    return try? JSONDecoder().decode(SharedUserMemoState.self, from: data)
  }


  // MARK: - Widget 更新

  /// WidgetCenter の呼び出しはここに閉じ込める
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
