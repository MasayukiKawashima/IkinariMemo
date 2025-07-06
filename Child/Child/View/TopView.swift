//
//  TopView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI

struct TopView: View {

// MARK: Properties

  private let titleHeightRatio: CGFloat = 0.11
  private let contentHeightRatio: CGFloat = 0.74
  private let spacerHeightRatio: CGFloat = 0.023
  private let adBannerHeight: CGFloat = 50

// MARK: Body

  var body: some View {
    GeometryReader { geometry in

      VStack(spacing: 0) {
        HStack {
          Spacer()

          Image(systemName: "line.3.horizontal")
            .font(.system(size: 32, weight: .bold))
            .padding(.trailing, 15)
        }
        .font(.system(size: 32, weight: .bold))

        Spacer().frame(height: geometry.size.height * spacerHeightRatio)

        Color.blue
          .frame(height: geometry.size.height * titleHeightRatio)
          .overlay(Text("Title"))

        Color.gray
          .frame(height: geometry.size.height * contentHeightRatio)
          .overlay(Text("Content"))

        Spacer().frame(height: geometry.size.height * spacerHeightRatio)

        Color.yellow
          .frame(height: adBannerHeight)
          .overlay(Text("Ad Banner"))
      }
    }
  }
}

#Preview {
  TopView()
}
