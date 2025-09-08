//
//  UserMemoListItemView.swift
//  Child
//
//  Created by 川島真之 on 2025/08/29.
//

import SwiftUI

struct UserMemoListItemView: View {
  
  private let item: UserMemoListItem
  
  private let memoTitleFontSizeRatio: CGFloat = 0.0202
  private let memoUpdatedDateFontSizeRatio: CGFloat = 0.0309
  
  init (item: UserMemoListItem) {
    self.item = item
  }
  
  var body: some View {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    VStack {
      HStack {
        Text(item.displayTitle)
          .font(.system(size: screenHeight * memoTitleFontSizeRatio))
          .lineLimit(1)
          .truncationMode(.tail)
          .padding(.leading, 6)
        Spacer()
      }
      
      HStack {
        Text(item.displayUpdatedDate)
          .font(.system(size: screenWidth * memoUpdatedDateFontSizeRatio))
          .foregroundColor(Color.gray)
          .padding(.leading, 6)
        Spacer()
      }
      
    }
    .contentShape(Rectangle())
  }
}

