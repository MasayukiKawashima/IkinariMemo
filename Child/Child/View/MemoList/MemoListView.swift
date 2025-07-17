//
//  MemoListView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/11.
//

import SwiftUI

struct MemoListView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: MemoListViewModel = MemoListViewModel()
  
  private let memoRowsHeightRatio: CGFloat = 0.0434
  
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      
      let fullHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
      
      List {
        Section {
          ForEach(viewModel.getTitlesFromAllMemoLists(), id: \.self) { memo in
            Text(memo)
              .frame(height: fullHeight * memoRowsHeightRatio)
              .lineLimit(1)
              .truncationMode(.tail)
          }
        }
      }
    }
  }
}

#Preview {
    MemoListView()
}
