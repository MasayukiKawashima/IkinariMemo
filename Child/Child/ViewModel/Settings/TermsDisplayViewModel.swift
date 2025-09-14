//
//  TermsDisplayViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/09/12.
//

import Foundation
import Combine

enum TermsType {
  case termsOfUse
  case privacyPolicy
  
  var title: String {
    switch self {
    case .termsOfUse: return "利用規約"
    case .privacyPolicy: return "プライバシーポリシー"
    }
  }
  
  var urlString: String {
    switch self {
      //各ページが完成するまでジドスタのページで代用
    case .termsOfUse: return "https://night-beryl-de2.notion.site/26e9e6db1ebc806ea495c3939f4d6106"
    case .privacyPolicy: return "https://night-beryl-de2.notion.site/26e9e6db1ebc8016aa15c51b51d2e895"
    }
  }
}

class TermsDisplayViewModel: ObservableObject {
  
  @Published var title: String
  @Published var urlString: String
  @Published var isLoading: Bool = true   // 読み込み中かどうかだけ保持
  
  init(type: TermsType) {
    self.title = type.title
    self.urlString = type.urlString
  }
}

