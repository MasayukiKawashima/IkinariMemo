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

// アップデート後、一度もアプリを起動せずにウィジェットを追加した場合に出るView
// アプリを起動していないとRealmと共有UserDefaultsの同期が行われていないので、Widgetが機能しない場合がある
// なのでアプリを一度立ち上げてもらうことを目的としたView

struct LaunchAppGuideView: View {


  // MARK: - Properties

  @ScaledMetric(relativeTo: .footnote) private var iconSize: CGFloat = 28


  // MARK: - Body

  var body: some View {
    VStack(spacing: 20) {
        Text("ウィジェットを利用するには\nアプリを一度起動する必要があります。")
            .font(.subheadline)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .foregroundStyle(.primary.opacity(0.6))

        HStack(spacing: 6) {
            Text("タップしてアプリを起動")

            Image(systemName: "hand.tap")
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.primary)
    }
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
