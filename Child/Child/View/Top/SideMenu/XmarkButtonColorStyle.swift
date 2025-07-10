//
//  XmarkButtonColorStyle.swift
//  Child
//
//  Created by 川島真之 on 2025/07/10.
//

import SwiftUI

struct XmarkButtonColorStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.gray.opacity(0.3) : Color.gray)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
