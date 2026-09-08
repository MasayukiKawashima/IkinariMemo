//
//  LatestMemoEntryView.swift
//  MemoWidgetsExtension
//
//  Created by 川島真之 on 2026/08/22.
//

import SwiftUI
import WidgetKit

struct LatestMemoEntryView: View {


  // MARK: - Properties

  let entry: LatestUserMemoEntry

  private var backgroundColor: Color {
    switch entry.displayState {
    case .memo:
      return .white
    case .noMemos, .notSynced:
      return .black.opacity(0.1)
    }
  }


  // MARK: - Body

  var body: some View {

    Group {
      switch entry.displayState {

      case .memo(let memo):
        MemoView(memo: memo)

      case .noMemos:
        NoMemosView()

      case .notSynced:
        LaunchAppGuideView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .containerBackground(for: .widget) {
      backgroundColor
    }
  }
}


// MARK: - Preview

private struct LatestMemoEntryPreviewWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "LatestMemoEntryPreview", provider: LatestMemoProvider()) { entry in
      LatestMemoEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
  }
}

#Preview(as: .systemMedium) {
  LatestMemoEntryPreviewWidget()
} timeline: {
  LatestUserMemoEntry(date: .now, displayState: .memo(SharedUserMemo(
    id: "1",
    title: "買い物リスト",
    content: "牛乳、卵、パン\n帰りにドラッグストアへ寄る",
    createdAt: .now,
    updatedAt: .now)))

  LatestUserMemoEntry(date: .now, displayState: .noMemos)

  LatestUserMemoEntry(date: .now, displayState: .notSynced)
}
