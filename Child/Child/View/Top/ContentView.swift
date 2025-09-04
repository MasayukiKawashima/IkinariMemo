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
  
  private let placeholderText: String = "本文"
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical, showsIndicators: true) {
        ZStack {
          TextEditor(text: Binding(
            get: { viewModel.textContent },
            set: { viewModel.updateContent($0) }
          ))
          .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
          HStack {
            Text("本文")
              .opacity(viewModel.textContent.isEmpty ? 0.3 : 0.0)
              .padding(.init(top: 9, leading: 8, bottom: 0, trailing: 0))
              .allowsHitTesting(false)
            
            Spacer()
          }
          .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
        }
      }
    }
  }
}


#Preview {
  ContentView()
}
