//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI

struct TitleView: View {

  @State private var title = ""
  private let titleTextSizeRatio: CGFloat = 0.074
  private let TextFieldLeadingPaddingRatio: CGFloat = 0.024

  var body: some View {
    GeometryReader { geometry in

      TextField("Title", text: $title)
        .font(.system(size: geometry.size.width * titleTextSizeRatio))
        .padding(.leading, geometry.size.width * TextFieldLeadingPaddingRatio)
    }
  }
}

#Preview {
    TitleView()
}
