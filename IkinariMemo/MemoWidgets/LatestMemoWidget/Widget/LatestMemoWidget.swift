//
//  LatestMemoWidget.swift
//  MemoWidgetsExtension
//
//  Created by 川島真之 on 2026/08/27.
//

import WidgetKit
import SwiftUI

struct LatestMemoWidget: Widget {

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: WidgetKind.latestMemo, provider: LatestMemoProvider()) { entry in
      LatestMemoEntryView(entry: entry)
    }
    .configurationDisplayName("最新のメモ")
    .description("直近に更新したメモを表示します。")
    .supportedFamilies([.systemMedium])
  }
}


// MARK: - Preview

#Preview(as: .systemMedium) {
  LatestMemoWidget()
} timeline: {
  LatestUserMemoEntry(date: .now, displayState: .memo(SharedUserMemo(
    id: "1",
    title: "買い物リスト",
    content: "牛乳、卵、パン\n帰りにドラッグストアへ寄る",
    createdAt: .now,
    updatedAt: .now)))

  LatestUserMemoEntry(date: .now, displayState: .memo(SharedUserMemo(
    id: "2",
    title: "とても長いタイトルの場合の表示を確認するためのメモです",
    content: String(repeating: "長い本文。", count: 40),
    createdAt: .now,
    updatedAt: .now.addingTimeInterval(-86400))))


  LatestUserMemoEntry(date: .now, displayState: .noMemos)

  LatestUserMemoEntry(date: .now, displayState: .notSynced)
}
