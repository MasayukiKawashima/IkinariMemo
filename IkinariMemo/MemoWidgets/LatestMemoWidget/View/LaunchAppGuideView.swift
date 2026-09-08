//
//  LaunchAppGuideView.swift
//  MemoWidgetsExtension
//
//  Created by 川島真之 on 2026/09/08.
//

//
//  LaunchAppGuideView.swift
//  MemoWidgetsExtension
//

import SwiftUI
import WidgetKit


// MARK: - 説明
// アプリ本体がまだ一度も同期していない場合に表示するView
// アップデート後、一度もアプリを起動せずにウィジェットを追加した場合に出る
// 「メモがありません」と表示すると不具合だと誤解されウィジェットを削除されてしまうため、
// 次に取るべき行動（アプリを開く）を示す

struct LaunchAppGuideView: View {


  // MARK: - Properties

  private let messageTextFontOpacityRate = 0.7

  @ScaledMetric(relativeTo: .footnote) private var iconSize: CGFloat = 28


  // MARK: - Body

  var body: some View {
    Text("アプリを開くと\n最新のメモが表示されます")
      .font(.subheadline)
      .multilineTextAlignment(.center)
      .foregroundStyle(.primary.opacity(messageTextFontOpacityRate))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(alignment: .topTrailing) {
        Image("EdgeOffIcon")
          .resizable()
          .scaledToFit()
          .frame(width: iconSize, height: iconSize)
      }
  }
}


// MARK: - Preview


private struct LaunchAppGuidePreviewWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "LaunchAppGuidePreview", provider: LatestMemoProvider()) { _ in
      LaunchAppGuideView()
        .containerBackground(for: .widget) { Color.black.opacity(0.15) }
    }
    .supportedFamilies([.systemMedium])
  }
}

#Preview(as: .systemMedium) {
  LaunchAppGuidePreviewWidget()
} timeline: {
  LatestUserMemoEntry(date: .now, displayState: .notSynced)
}
