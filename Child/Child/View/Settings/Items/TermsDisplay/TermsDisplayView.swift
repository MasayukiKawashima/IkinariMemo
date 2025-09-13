//
//  TermsDisplayView.swift
//  Child
//
//  Created by 川島真之 on 2025/09/11.
//

// TermsDisplayView.swift
import SwiftUI

struct TermsDisplayView: View {
  
  @StateObject private var viewModel: TermsDisplayViewModel
  
  init(type: TermsType) {
    _viewModel = StateObject(wrappedValue: TermsDisplayViewModel(type: type))
  }
  
  var body: some View {
    ZStack {
      WebViewWrapper(urlString: viewModel.urlString, viewModel: viewModel)
      
      if viewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .scaleEffect(1.5)
          .padding(20)
          .background(Color.white.opacity(0.8))
          .cornerRadius(10)
      }
    }
    .customBackButton()
  }
}



//#Preview {
//    TermsDisplayView()
//}
