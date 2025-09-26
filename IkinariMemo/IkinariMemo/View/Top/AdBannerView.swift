//
//  AdBannerView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/08.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: AdBannerViewModel = AdBannerViewModel()
  
  // MARK: - Methods
  
  func makeUIView(context: Context) -> BannerView {
    let screenWidth = UIScreen.main.bounds.width
    // Adaptive Banner のサイズを取得
    let adSize = currentOrientationAnchoredAdaptiveBanner(width: screenWidth)
    
    let banner = BannerView(adSize: adSize)
    banner.adUnitID = viewModel.adUnitID(key: "TopScreenBannerID")
 
    banner.rootViewController = UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
      .first
    banner.load(Request())
    return banner
  }

  func updateUIView(_ uiView: BannerView, context: Context) {}
}


