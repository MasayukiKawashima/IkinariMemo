//
//  TermsDisplayView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/11.
//

// TermsDisplayView.swift
import SwiftUI

struct TermsDisplayView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: TermsDisplayViewModel
  
  // MARK: - Init
  
  init(type: TermsType) {
    _viewModel = StateObject(wrappedValue: TermsDisplayViewModel(type: type))
  }
  
  // MARK: - Body
  
  var body: some View {
    ZStack {
      WebView(urlString: viewModel.urlString, viewModel: viewModel)
      
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
