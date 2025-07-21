//
//  ContentView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
  
  @StateObject private var viewModel: ContentViewModel = ContentViewModel()
  
  private let TextEditorSidePaddingRatio: CGFloat = 0.024
  
  var body: some View {
    GeometryReader { geometry in
      TextField("", text: Binding(
        get: { viewModel.textContent },
        set: { viewModel.updateContent($0) }
      ))
        .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
    }
  }
}


#Preview {
  ContentView()
}
