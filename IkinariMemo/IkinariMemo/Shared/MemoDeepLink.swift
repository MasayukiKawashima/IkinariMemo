//
//  MemoDeepLink.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/10.
//

import Foundation

enum MemoDeepLink {


  // MARK: - Properties

  static let scheme = "ikinarimemo"
  private static let memoHost = "memo"
  private static let idKey = "id"


  // MARK: - DisplayTarget

  enum DisplayTarget: Equatable {

    case memo(id: String)

    /// 空の新規メモを表示する（通常のアプリ起動と同じ状態）
    /// メモ以外の状態の Widget タップ、および解釈できない URL がここに落ちる
    case newMemo
  }


  // MARK: - 生成 Widget 側から利用

  /// 表示内容に対応する URL を作る
  /// - Returns: .newMemo の場合は nil

  static func url(for target: DisplayTarget) -> URL? {

    switch target {
    case .memo(let id):
      guard !id.isEmpty else { return nil }

      var components = URLComponents()
      components.scheme = scheme
      components.host = memoHost
      components.queryItems = [URLQueryItem(name: idKey, value: id)]
      return components.url

    case .newMemo:
      return nil
    }
  }


  // MARK: - 解析 アプリ本体側から利用

  /// 受け取った URL を表示内容へ変換する
  /// 解釈できない URL は握り潰さず .newMemo として返し、
  /// 「通常起動と同じ状態にする」という判断を呼び出し側に明示的に伝える
  ///
  static func displayTarget(from url: URL) -> DisplayTarget {

    guard url.scheme == scheme,
          url.host == memoHost,
          let id = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == idKey })?
            .value,
          !id.isEmpty
    else {
      #if DEBUG
      print("[MemoDeepLink] 解釈できない URL のため新規メモを表示します: \(url)")
      #endif
      return .newMemo
    }

    return .memo(id: id)
  }
}
