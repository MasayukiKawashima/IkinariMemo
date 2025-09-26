//
//  UserMemo.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/13.
//

import Foundation
import RealmSwift

class UserMemo: Object, ObjectKeyIdentifiable {
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var title: String = ""
  @Persisted var content: String = ""
  @Persisted var createdAt: Date = Date()
  @Persisted var updatedAt: Date = Date()

  override static func primaryKey() -> String? {
    return "_id"
  }
}
