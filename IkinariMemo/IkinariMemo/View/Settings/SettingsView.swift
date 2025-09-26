//
//  SettingsView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/11.
//

import SwiftUI

struct SettingsView: View {

  // MARK: - Properties

  private let bottomTextFontSizeRatio: CGFloat = 0.016
  private let bottomTextBottomPaddingRatio: CGFloat = 0.011
  private let listItemHeightRatio: CGFloat = 0.041

  private let screenHeight = UIScreen.main.bounds.height
  private let screenWidth = UIScreen.main.bounds.width

  // MARK: - Body

  var body: some View {
    NavigationStack {
      VStack {
        List {
          Section {
            SettingItemView(title: "データの削除", destination: DeleteDataView())
              .frame(height: screenHeight * listItemHeightRatio)
          }
          Section {
            SettingItemView(title: "利用規約", destination: TermsDisplayView(type: .termsOfUse))
              .frame(height: screenHeight * listItemHeightRatio)
            SettingItemView(title: "プライバシーポリシー", destination: TermsDisplayView(type: .privacyPolicy))
              .frame(height: screenHeight * listItemHeightRatio)
          }
          Section {
            ContactItemView()
              .frame(height: screenHeight * listItemHeightRatio)
          }
        }
        .scrollContentBackground(.hidden)

        Spacer()

        VStack {
          Text("Version 1.0.0")
          Text("© 2025 Masayuki Kawashima")
        }
        .padding(.bottom, screenHeight * bottomTextBottomPaddingRatio)
        .font(.system(size: screenHeight * bottomTextFontSizeRatio))
        .foregroundStyle(Color.customDarkGrayColor)
      }
      .background(Color.listBackgroundColor)
      .customBackButton()
    }
  }
}

#Preview {
  SettingsView()
}
