//
//  TermsDisplayViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/09/12.
//

import Foundation

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
    case .termsOfUse: return "https://www.notion.so/1619e6db1ebc801297fdfef8e61cc911"
    case .privacyPolicy: return "https://www.notion.so/1619e6db1ebc801097eed65897bb162f"
    }
  }
}


class TermsDisplayViewModel: ObservableObject {
  
  @Published var title: String
  @Published var urlString: String
  
  init(type: TermsType) {
    self.title = type.title
    self.urlString = type.urlString
  }
}
