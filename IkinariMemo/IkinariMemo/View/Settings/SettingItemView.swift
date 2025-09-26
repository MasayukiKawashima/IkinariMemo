//
//  SettingItemView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/11.
//

import SwiftUI

struct SettingItemView<Destination: View>: View {

  // MARK: - Properties

  let title: String
  let destination: Destination

  // MARK: - Body

  var body: some View {
    NavigationLink(destination: destination) {
      HStack {
        Text(title)
          .foregroundColor(.primary)
      }
      .padding(.vertical, 8)
    }
  }
}

#Preview {
  SettingItemView(title: "Test", destination: Text("Test"))
}
