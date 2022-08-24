//
//  RecruitingTests.swift
//

import XCTest
@testable import TCA_example
import ComposableArchitecture

// MARK: 検索機能テストデータ
class SearchTests: XCTestCase {
    
    // MARK: 検索一覧レスポンス成功テスト
    func testSucceedSearchContents() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: SearchStore.State(),
            reducer: SearchStore.reducer,
            environment: SearchStore.Environment(
                searchClient: SearchClient { request in
                    Effect(value: SearchUserResponse.Users.mockUsers)
                        .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                        .eraseToEffect()
                }
            )
        )
        // 検索一覧取得アクション
        store.send(.getContent)
        // 受け取るアクション
        store.receive(.response(.success(SearchUserResponse.Users.mockUsers))) { response in
            response.users = SearchUserResponse.Users.mockUsers
            response.errorStatus = Bindable<String>(nil)
        }
    }
    
    // MARK: 検索一覧レスポンス失敗テスト
    func testFairureSearchContents() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: SearchStore.State(),
            reducer: SearchStore.reducer,
            environment: SearchStore.Environment(
                searchClient: SearchClient { request in
                    Effect(error: .serverError)
                        .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                        .eraseToEffect()
                }
            )
        )
        // 検索一覧取得アクション
        store.send(.getContent)
        // 受け取るアクション
        store.receive(.response(.failure(APIError.serverError))) { response in
            response.users = nil
            response.errorStatus = Bindable<String>(APIError.serverError.localize)
        }
    }
    
}
