//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI

struct TitleView: View {
  
  @StateObject private var viewModel: TitleViewModel = TitleViewModel()
  // iPhone16Proの画面のHeight874（CSSピクセル）を基準に算出
  private let titleTextSizeRatio: CGFloat = 0.074
  private let TextFieldSidePaddingRatio: CGFloat = 0.024
  
  var body: some View {
    GeometryReader { geometry in
      
      TextField("Title", text: $viewModel.title)
        .font(.system(size: geometry.size.width * titleTextSizeRatio))
        .padding(.leading, geometry.size.width * TextFieldSidePaddingRatio)
        .padding(.trailing, geometry.size.width * TextFieldSidePaddingRatio)
    }
  }
}

#Preview {
  TitleView()
}
