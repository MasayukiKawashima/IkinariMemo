//
//  ViewExtension.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/08.
//

import Foundation
import SwiftUI

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}
