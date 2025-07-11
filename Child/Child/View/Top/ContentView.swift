//
//  ContentView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject private var ViewModel: ContentViewModel = ContentViewModel()
  private let TextEditorSidePaddingRatio: CGFloat = 0.024
  
  var body: some View {
    GeometryReader { geometry in
      TextEditor(text: $ViewModel.textContent)
        .padding(.leading, geometry.size.width * TextEditorSidePaddingRatio)
        .padding(.trailing, geometry.size.width * TextEditorSidePaddingRatio)
    }
  }
}

#Preview {
  ContentView()
}
