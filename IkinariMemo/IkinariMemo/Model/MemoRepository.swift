//
//  MemoRepository.swift
//  IkinariMemo
//

import Foundation
import RealmSwift

/// テスト時にモック差し替えができるようにするためのプロトコル（任意）
protocol MemoRepositoryProtocol {
  func fetchAllSortedByCreatedAt() -> Results<UserMemo>
  func fetch(id: String) -> UserMemo?
  func hasAnyMemo() -> Bool
  func observeAll(_ onChange: @escaping () -> Void) -> NotificationToken?
  func save(_ memo: UserMemo, title: String?, content: String?)
  func delete(_ memo: UserMemo)
  func deleteAll()
  func reloadWidgetTimeline()
}

/// Realm への全アクセスを集約する層。
/// writeAndSyncStore は書き込み成功後に共有 UserDefaults（updateSharedStore）を必ず更新する。
/// Widget のリロード（reloadWidget）は頻度制限があるため writeAndSyncStore には含めず、
/// 削除時や編集終了時など必要な箇所で明示的に呼ぶ。
final class MemoRepository: MemoRepositoryProtocol {


  // MARK: - Properties

  static let shared = MemoRepository()
  private let realm: Realm


  // MARK: - Init

  /// テストではインメモリ Realm などを注入できる
  init(realm: Realm? = nil) {
    if let realm {
      self.realm = realm
    } else {
      do {
        self.realm = try Realm()
      } catch {
        fatalError("Realm の初期化に失敗しました: \(error)")
      }
    }
  }


  // MARK: - 読み取り

  func fetchAllSortedByCreatedAt() -> Results<UserMemo> {
    realm.objects(UserMemo.self).sorted(byKeyPath: "createdAt", ascending: false)
  }

  func fetch(id: String) -> UserMemo? {
      guard let objectID = try? ObjectId(string: id) else { return nil }
      return realm.object(ofType: UserMemo.self, forPrimaryKey: objectID)
    }

  func hasAnyMemo() -> Bool {
    !realm.objects(UserMemo.self).isEmpty
  }

  func observeAll(_ onChange: @escaping () -> Void) -> NotificationToken? {
    fetchAllSortedByCreatedAt().observe { _ in onChange() }
  }


  // MARK: - 書き込み

  /// メモの新規保存 / 更新。
  /// title / content は変更したい項目だけ渡す（nil の項目は据え置き）。
  /// ※ プロパティの変更は必ず write トランザクション内で行う必要があるため、
  ///   値の代入は writeAndSyncStore の中で実施している。
  func save(_ memo: UserMemo, title: String? = nil, content: String? = nil) {
    // 逐次保存。共有 UserDefaults の更新のみ（writeAndSyncStore 内で実施）。
    // Widget のリロードは頻度制限があるため行わず、編集終了時に reloadWidgetTimeline() で行う。
    writeAndSyncStore {
      if let title { memo.title = title }
      if let content { memo.content = content }
      memo.updatedAt = Date()
      realm.add(memo, update: .modified)
    }
  }

  func delete(_ memo: UserMemo) {
    writeAndSyncStore {
      realm.delete(memo)
    }
    // 削除は単発操作なので即時に Widget を更新する
    WidgetSync.reloadWidget()
  }

  func deleteAll() {
    writeAndSyncStore {
      realm.delete(realm.objects(UserMemo.self))
    }
    WidgetSync.reloadWidget()
  }

  /// 編集終了時など、明示的に Widget のタイムラインを更新したいときに呼ぶ。
  func reloadWidgetTimeline() {
    WidgetSync.reloadWidget()
  }


  // MARK: - 共通処理

  /// write トランザクションを実行し、成功したら共有 UserDefaults を最新へ更新する。
  /// Widget のリロードは含めない（必要な箇所で WidgetSync.reloadWidget を呼ぶ）。
  /// - Parameter updates: write トランザクション内で行うデータ更新処理
  private func writeAndSyncStore(_ updates: () -> Void) {
    do {
      try realm.write {
        updates()
      }
      WidgetSync.updateSharedStore()
    } catch {
      assertionFailure("Realm 書き込みに失敗しました: \(error)")
    }
  }
}
