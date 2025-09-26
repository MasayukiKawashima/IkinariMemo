//
//  WebView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/12.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  
  // MARK: - Properties
  
  let urlString: String
  @ObservedObject var viewModel: TermsDisplayViewModel
  
  // MARK: - Methods
  
  func makeCoordinator() -> Coordinator {
    Coordinator(viewModel: viewModel)
  }
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    
    if let url = URL(string: urlString) {
      webView.load(URLRequest(url: url))
    }
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {}
  
  // MARK: - Coordinator
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var viewModel: TermsDisplayViewModel
    
    init(viewModel: TermsDisplayViewModel) {
      self.viewModel = viewModel
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      viewModel.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      viewModel.isLoading = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      viewModel.isLoading = false
    }
  }
}


