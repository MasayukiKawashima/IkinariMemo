//
//  View+KeyboardCloseToolbar.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/09/23.
//

import SwiftUI

extension View {
  @ViewBuilder
  func keyboardCloseToolbar(onClose: @escaping () -> Void) -> some View {
    if #available(iOS 26, *) {
      self.toolbar {
        KeyboardCloseToolbarContent(onClose: onClose)
          .sharedBackgroundVisibility(.hidden)
      }
    } else {
      self.toolbar {
        KeyboardCloseToolbarContent(onClose: onClose)
      }
    }
  }
}


// MARK: - Toolbar Content

private struct KeyboardCloseToolbarContent: ToolbarContent {
  let onClose: () -> Void

  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .keyboard) {
      Spacer()
      Button(action: onClose) {
        Text("閉じる")
          .lineLimit(1)
          .fixedSize() 
          .foregroundStyle(.black)
          .padding(.vertical, 6)
          .padding(.horizontal, 12)
          .background(.white, in: RoundedRectangle(cornerRadius: 20))
      }
      .buttonStyle(.plain)
    }
  }
}
