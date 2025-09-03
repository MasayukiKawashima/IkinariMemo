//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI
import RealmSwift

struct TitleView: View {
  @StateObject private var viewModel = TitleViewModel()

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal, showsIndicators: true) {
        TextField("Title", text: Binding(
          get: { viewModel.title },
          set: { viewModel.updateTitle($0) }
        ))
        .lineLimit(1)
        .font(.system(size: geometry.size.width * 0.074))
        .padding(.horizontal, geometry.size.width * 0.024)
      }
    }
  }
}


#Preview {
      TitleView()
}
