//
//  SettingsView.swift
//  Child
//
//  Created by 川島真之 on 2025/09/11.
//

import SwiftUI

struct SettingsView: View {
  
  // MARK: - Properties
  
  private let bottomTextFontSizeRatio: CGFloat = 0.016
  
  private let screenHeight = UIScreen.main.bounds.height
  private let screenWidth = UIScreen.main.bounds.width
  
  // MARK: - Body
  
  var body: some View {
      NavigationStack {
          VStack {
              List {
                  Section {
                    SettingItemView(title: "データの削除", destination: DeleteDataView())
                  }
                  Section {
                    SettingItemView(title: "利用規約", destination: TermsDisplayView(type: .termsOfUse))
                    SettingItemView(title: "プライバシーポリシー", destination: TermsDisplayView(type: .privacyPolicy))
                    SettingItemView(title: "お問い合わせ", destination: ContactView())
                  }
              }
              .scrollContentBackground(.hidden)

              Spacer()

              VStack {
                  Text("Version 1.0.0")
                  Text("© 2025 Masayuki Kawashima")
              }
              .font(.system(size: screenHeight * bottomTextFontSizeRatio))
              .foregroundStyle(Color(red: 67/255, green: 67/255, blue: 67/255))
          }
          .background(Color.listBackgroundColor)
          .customBackButton()
      }
  }
}

#Preview {
    SettingsView()
}
