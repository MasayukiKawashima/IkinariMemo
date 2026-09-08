//
//  LatestMemoSynchronizer.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/06.
//

import Foundation
import RealmSwift


// MARK: - 説明
// LatestMemoSynchronizerはRealmのUserMemoを監視して、監視開始時とUserMemoの変更時に共有UserDefaultsへ最新メモを同期する（sync）役割を持ったクラス


@MainActor
final class LatestMemoSynchronizer {


  // MARK: - Properties

  // resultsとtoken（つまり、状態）を保持しなければいけないのでシングルトンとする
  static let shared = LatestMemoSynchronizer()

  // Results と NotificationToken の両方を保持する必要がある。
  // Results を保持しないと解放されて通知が止まる
  private var results: Results<UserMemo>?
  private var token: NotificationToken?


    // MARK: - Init

  private init() {}


  // MARK: -  監視と通知時の処理
  // 起動時などで呼ばれ、UserMemoを監視を始める
  // 監視開始時とUserMemoの変更時にsyncを呼ぶ

  func start() {
    guard token == nil else { return }   // 二重監視を防ぐ

    do {
      let realm = try Realm()
      let results = realm.objects(UserMemo.self)
        .sorted(byKeyPath: "updatedAt", ascending: false)

      self.results = results
      self.token = results.observe { [weak self] change in
        switch change {
          // 監視開始時に必ず一度、initialで流れる
        case .initial(let memos):
          self?.sync(memos.first)
          // 変更時
        case .update(let memos, _, _, _):
          self?.sync(memos.first)
          // エラー時はデータを流さない
        case .error(let error):
          print("[LatestMemoSynchronizer] Realm の監視に失敗: \(error)")
        }
      }
    } catch {
      print("[LatestMemoSynchronizer] Realm のオープンに失敗: \(error)")
    }
  }

  /// フォアグラウンド復帰時の保険。
  /// 差分ゲートがあるので、変化がなければ何も起きない
  func refreshNow() {
    guard let results else {
      start()   // 起動時に Realm オープンへ失敗していた場合のリトライ
      return
    }
    sync(results.first)
  }


  // MARK: - 値を同期する処理
  // 監視時、監視開始時に共有UserDefaultsへ値を同期するメソッド

  private func sync(_ memo: UserMemo?) {
    let shared = memo.map {
      SharedUserMemo(
        id: $0.id.stringValue,
        title: $0.title,
        content: $0.content,
        createdAt: $0.createdAt,
        updatedAt: $0.updatedAt
      )
    }
    SharedUserMemoStore.saveLatestMemo(shared)
  }

  deinit {
    token?.invalidate()
  }
}
