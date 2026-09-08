//
//  SharedUserMemo.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2026/08/25.
//

import Foundation

struct SharedUserMemo: Codable, Equatable {

   let id: String
   let title: String
   let content: String
   let createdAt: Date
   let updatedAt: Date
}
