//
//  DisplayedMemoUpdaterForWidgetLinkTests.swift
//  IkinariMemoTests
//
//  Created by 川島真之 on 2026/09/18.
//

import XCTest
import RealmSwift
@testable import IkinariMemo

final class DisplayedMemoUpdaterForWidgetLinkTests: XCTestCase {


  // MARK: - Properties

  var mockMemoRepository: MockMemoRepository!
  var mockCurrentUserMemoViewModel: MockCurrentUserMemoViewModel!
  var upDater: DisplayedMemoUpdaterForWidgetLink!


  // MARK: - LifeCycle

  override func setUp() {
    super.setUp()

    mockMemoRepository = MockMemoRepository()
    mockCurrentUserMemoViewModel = MockCurrentUserMemoViewModel()
    upDater = DisplayedMemoUpdaterForWidgetLink(repository: mockMemoRepository,
                                                currentUserMemoViewModel: mockCurrentUserMemoViewModel)
  }

  override func tearDown() {
    mockMemoRepository = nil
    mockCurrentUserMemoViewModel = nil
    upDater = nil

    super.tearDown()
  }


  // MARK: - TestCase

  // メモが存在していたらCurrentUserMemoViewModelのupDate()がよばれ、メモが更新されることをテスト
  func test_updateDisplayTarget_メモが存在する場合は表示するUserMemoを更新する() {

    let memo = UserMemo()
    memo.id = ObjectId.generate()
    let stringID = memo.id.stringValue
    mockMemoRepository.stubUserMemo = memo
    let url = MemoDeepLink.url(for: .memo(id: stringID))!

    let result = upDater.updateDisplayTarget(from: url)

    // 一回しか更新されていないことを検証
    XCTAssertEqual(mockCurrentUserMemoViewModel.upDateMemos.count, 1)
    // 更新内容があっているかを検証
    XCTAssertEqual(mockCurrentUserMemoViewModel.upDateMemos.first, memo)
    // .updatedが返されているかを検証
    XCTAssertEqual(result, .updated)
  }

  // メモが存在していなかった場合いは.notUpdatedが返されて何もしない。表示するUserMemoも更新しない。
  func test_updateDisplayTarget_メモが存在していない場合は表示するUserMemoは更新されない() {

    mockMemoRepository.stubUserMemo = nil
    let stringID = ObjectId.generate().stringValue
    let url = MemoDeepLink.url(for: .memo(id: stringID))!

    let result = upDater.updateDisplayTarget(from: url)

    // .notUpdatedが呼ばれていることを検証
    XCTAssertEqual(result, .notUpdated)
    // 表示するUserMemoが更新されていないことを検証
    XCTAssertEqual(mockCurrentUserMemoViewModel.upDateMemos.isEmpty, true)
  }

  // 解釈不能なURLだった場合も.notUpdatedが返されて何もしない。表示するUserMemoも更新しない。
  // ちなみに、そもそもWidgetからnil（.widgetURL(nil)だった場合のこと。MemoDeepLink.urlで.newMemoが選択された場合はnilが返される）がアプリ本体に送られたときは
  //　アプリがデフォルト起動する（WidgetKitの標準仕様）ので、そもそもupdateDisplayTarget(from:)が呼ばれない。なのでその場合の検証はここのテストの範囲外となる。
  func test_updateDisplayTarget_解釈不能なURLの場合は表示するUserMemoは更新されない() {

    let url = URL(string: "ikinarimemo://???????")!

    let result = upDater.updateDisplayTarget(from: url)

    // .notUpdatedが呼ばれていることを検証
    XCTAssertEqual(result, .notUpdated)
    // 表示するUserMemoが更新されていないことを検証
    XCTAssertEqual(mockCurrentUserMemoViewModel.upDateMemos.isEmpty, true)
  }

}


// MARK: - Mock

class MockMemoRepository: MemoRepositoryProtocol {


  // 各テストで注入
  var stubUserMemo: UserMemo?

  // 期待通りの挙動をすれば一つのIDしか代入されないか一つも代入されないので、それをを確認するためにあえて配列で定義
  // 2つ以上入っていた場合はおかしい
  var fetchedIDs: [String] = []

  func fetch(id: String) -> IkinariMemo.UserMemo? {
    fetchedIDs.append(id)
    return stubUserMemo
  }

  // 以下は未使用

  func fetchAllSortedByCreatedAt() -> RealmSwift.Results<IkinariMemo.UserMemo> { fatalError("") }
  func fetchLatestUpdated() -> IkinariMemo.UserMemo? { UserMemo() }
  func hasAnyMemo() -> Bool { false }
  func observeAll(_ onChange: @escaping () -> Void) -> RealmSwift.NotificationToken? { nil }
  func save(_ memo: IkinariMemo.UserMemo, title: String?, content: String?) {}
  func delete(_ memo: IkinariMemo.UserMemo) {}
  func deleteAll() {}
  func reloadWidgetTimeline() {}
}

class MockCurrentUserMemoViewModel: CurrentUserMemoViewModelProtocol {

  //　ここも期待通りであれば一回しか更新されない、もしくは更新がされないはずなので、それの確認のため配列で定義
  // 2つ以上メモが代入されていたらおかしい
  var upDateMemos: [UserMemo] = []

  func upDate(userMemo: IkinariMemo.UserMemo) {
    upDateMemos.append(userMemo)
  }
}
