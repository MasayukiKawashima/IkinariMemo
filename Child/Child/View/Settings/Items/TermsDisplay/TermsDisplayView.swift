//
//  TermsDisplayView.swift
//  Child
//
//  Created by 川島真之 on 2025/09/11.
//

import SwiftUI

struct TermsDisplayView: View {
  
  @StateObject private var viewModel: TermsDisplayViewModel
  
  init(type: TermsType) {
    _viewModel = StateObject(wrappedValue: TermsDisplayViewModel(type: type))
  }
  
  var body: some View {
    VStack {
      WebViewWrapper(urlString: viewModel.urlString)
    }
    .customBackButton()
  }
}

//#Preview {
//    TermsDisplayView()
//}
