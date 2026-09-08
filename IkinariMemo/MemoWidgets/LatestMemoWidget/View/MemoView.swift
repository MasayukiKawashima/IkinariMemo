//
//  MemoView.swift
//  MemoWidgetsExtension
//
//  Created by 川島真之 on 2026/09/08.
//

//
//  MemoView.swift
//  MemoWidgetsExtension
//

import SwiftUI
import WidgetKit

struct MemoView: View {


  // MARK: - Properties

  let memo: SharedUserMemo

  private let contentTextFontOpacityRate = 0.7
  private let dateTextFontOpacityRate: Double = 0.7
  private let separatorHeight: CGFloat = 0.5
  private let titleLineLimit = 1
  private let vStackSpacing: CGFloat = 6

  @ScaledMetric(relativeTo: .footnote) private var iconSize: CGFloat = 28


  // MARK: - Body

  var body: some View {
    VStack(alignment: .leading, spacing: vStackSpacing) {

      HStack {
        Text(memo.updatedAt, format: .dateTime.year().month().day())
          .font(.footnote)
          .foregroundStyle(.primary.opacity(dateTextFontOpacityRate))

        Spacer()

        Image("EdgeOffIcon")
          .resizable()
          .scaledToFit()
          .frame(width: iconSize, height: iconSize)
      }

      Text(memo.title)
        .font(.headline)
        .lineLimit(titleLineLimit)

      Rectangle()
        .frame(height: separatorHeight)
        .foregroundStyle(Color.mainColor)

      Text(memo.content)
        .font(.footnote)
        .foregroundStyle(.primary.opacity(contentTextFontOpacityRate))
        .truncationMode(.tail)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}


// MARK: - Preview

// プレビュー専用に MemoView をラップした簡易 Widget
private struct MemoPreviewWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "MemoPreview", provider: LatestMemoProvider()) { entry in
      if case .memo(let memo) = entry.displayState {
        MemoView(memo: memo)
          .containerBackground(for: .widget) { Color.white }
      }
    }
    .supportedFamilies([.systemMedium])
  }
}

#Preview(as: .systemMedium) {
  MemoPreviewWidget()
} timeline: {
  LatestUserMemoEntry(date: .now, displayState: .memo(SharedUserMemo(
    id: "1",
    title: "買い物リスト",
    content: "牛乳、卵、パン\n帰りにドラッグストアへ寄る",
    createdAt: .now,
    updatedAt: .now)))
}
