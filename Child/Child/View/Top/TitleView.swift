//
//  TitleView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI
import RealmSwift

struct TitleView: View {
  
  @ObservedRealmObject var currentUserMemo: UserMemo
  @StateObject private var viewModel: TitleViewModel
  
  init(currentUserMemo: UserMemo) {
    _viewModel = StateObject(wrappedValue: TitleViewModel(currentUserMemo: currentUserMemo))
    self.currentUserMemo = currentUserMemo
    }
  private let titleTextSizeRatio: CGFloat = 0.074
  private let TextFieldSidePaddingRatio: CGFloat = 0.024
  
  var body: some View {
    GeometryReader { geometry in
      TextField("Title", text: $viewModel.title)
        .font(.system(size: geometry.size.width * titleTextSizeRatio))
        .padding(.horizontal, geometry.size.width * TextFieldSidePaddingRatio)
    }
  }
}


#Preview {
      let previewData = UserMemo()
      TitleView(currentUserMemo: previewData)
}
