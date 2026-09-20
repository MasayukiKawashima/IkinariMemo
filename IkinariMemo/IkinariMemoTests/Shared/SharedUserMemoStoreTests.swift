//
//  SharedUserMemoStoreTests.swift
//  IkinariMemoTests
//

import XCTest
@testable import IkinariMemo

final class SharedUserMemoStoreTests: XCTestCase {

    // 各テスト前後に共有ストアを .noMemos に戻して、テスト間の状態を独立させる。
    // 現行仕様では saveLatestMemo(nil) はキー削除ではなく .noMemos を書き込むため、
    // 未同期(nil)状態は作れない。公開APIのみで初期化するブラックボックス方針。
    override func setUpWithError() throws {
        SharedUserMemoStore.saveLatestMemo(nil)
    }

    override func tearDownWithError() throws {
        SharedUserMemoStore.saveLatestMemo(nil)
    }

    // MARK: - Helpers

    private func makeMemo(
        id: String = "test-id",
        title: String = "タイトル",
        content: String = "本文",
        createdAt: Date = Date(timeIntervalSince1970: 1_000),
        updatedAt: Date = Date(timeIntervalSince1970: 2_000)
    ) -> SharedUserMemo {
        SharedUserMemo(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    /// 状態から SharedUserMemo を取り出す。.memo 以外は nil。
    private func loadedMemo() -> SharedUserMemo? {
        if case .memo(let memo) = SharedUserMemoStore.loadLatestMemoState() {
            return memo
        }
        return nil
    }

    // MARK: - 保存 → 読み込み

    func test_saveThenLoad_returnsSameMemo() {
        let memo = makeMemo()

        SharedUserMemoStore.saveLatestMemo(memo)

        XCTAssertEqual(SharedUserMemoStore.loadLatestMemoState(), .memo(memo))
    }

    // MARK: - nil 保存で .noMemos になる

    func test_saveNil_loadReturnsNoMemos() {
        SharedUserMemoStore.saveLatestMemo(makeMemo())
        XCTAssertEqual(SharedUserMemoStore.loadLatestMemoState(), .memo(makeMemo()))

        SharedUserMemoStore.saveLatestMemo(nil)

        XCTAssertEqual(SharedUserMemoStore.loadLatestMemoState(), .noMemos)
    }

    // MARK: - 文字数切り詰め

    func test_saveTrimsTitleTo100() {
        let longTitle = String(repeating: "あ", count: 150)
        SharedUserMemoStore.saveLatestMemo(makeMemo(title: longTitle))

        let loaded = loadedMemo()

        XCTAssertEqual(loaded?.title.count, 100)
        XCTAssertEqual(loaded?.title, String(repeating: "あ", count: 100))
    }

    func test_saveTrimsContentTo500() {
        let longContent = String(repeating: "い", count: 600)
        SharedUserMemoStore.saveLatestMemo(makeMemo(content: longContent))

        let loaded = loadedMemo()

        XCTAssertEqual(loaded?.content.count, 500)
        XCTAssertEqual(loaded?.content, String(repeating: "い", count: 500))
    }

    func test_saveDoesNotTrimStringsAtLimit() {
        let title = String(repeating: "a", count: 100)   // ちょうど上限
        let content = String(repeating: "b", count: 500) // ちょうど上限
        SharedUserMemoStore.saveLatestMemo(makeMemo(title: title, content: content))

        let loaded = loadedMemo()

        XCTAssertEqual(loaded?.title, title)
        XCTAssertEqual(loaded?.content, content)
    }
}
