//
//  MemoDeepLinkTests.swift
//  IkinariMemoTests
//
//  Created by 川島真之 on 2026/09/20.
//

import XCTest
import RealmSwift
@testable import IkinariMemo

final class MemoDeepLinkTests: XCTestCase {


  // MARK: - TestCase

  // MARK: - url

  func test_url_DisplayTargetがmemoの場合はURLを返すこと() {

    let id = ObjectId.generate().stringValue
    let result = MemoDeepLink.url(for: .memo(id: id))

    XCTAssertEqual(result?.absoluteString, "ikinarimemo://memo?id=\(id)")
  }

  func test_url_DisplayTargetがnewMemoの場合はnilを返すこと() {

    let result = MemoDeepLink.url(for: .newMemo)

    XCTAssertNil(result)
  }


  // MARK: - displayTarget

  func test_displayTarget_解釈できるurlが渡された場合はmemoが返されること() {

    let id = ObjectId.generate().stringValue
    let url = URL(string: "ikinarimemo://memo?id=\(id)")!

    let result = MemoDeepLink.displayTarget(from: url)

    XCTAssertEqual(result, .memo(id: id))
  }

  func test_displayTarget_解釈できないURLが渡された場合はnewMemoが返されること() {

    let url = URL(string: "ikinarimemo://??????")!

    let result = MemoDeepLink.displayTarget(from: url)

    XCTAssertEqual(result, .newMemo)
  }

}
