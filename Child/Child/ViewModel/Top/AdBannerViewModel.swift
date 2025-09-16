//
//  AdBannerViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/09/11.
//

import Foundation

class AdBannerViewModel: ObservableObject {
  
  // MARK: - Methods
  
  func adUnitID(key: String) -> String? {
    guard let adUnitIDs = Bundle.main.object(forInfoDictionaryKey: "AdUnitIDs") as? [String: String] else {
      return nil
    }
    return adUnitIDs[key]
  }
  
}
