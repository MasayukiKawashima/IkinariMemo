//
//  CustomBackButton.swift
//  Child
//
//  Created by 川島真之 on 2025/09/08.
//

import SwiftUI

struct CustomBackButton: ViewModifier {
  
  @Environment(\.dismiss) var dismiss
  
  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {
            dismiss()
          }) {
            // ★ 「< 戻る」を再現
            HStack(spacing: 4) {
              Image(systemName: "chevron.left")
              Text("戻る")
            }
            .foregroundStyle(Color.gray)
          }
        }
      }
  }
}

