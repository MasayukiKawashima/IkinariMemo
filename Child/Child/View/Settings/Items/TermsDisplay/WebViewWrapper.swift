//
//  WebViewWrapper.swift
//  Child
//
//  Created by 川島真之 on 2025/09/12.
//

import Foundation
import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {

  let urlString: String
  
  func makeUIView(context: Context) -> WKWebView {
      let webView = WKWebView()
      if let url = URL(string: urlString) {
          webView.load(URLRequest(url: url))
      }
      return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {}
}
