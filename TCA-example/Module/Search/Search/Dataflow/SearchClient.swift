//
//  SearchClient.swift
//

import Foundation
import ComposableArchitecture
import Combine

struct SearchClient {
    var users: (SearchRequest) -> Effect<SearchUserResponse.Users, APIError>
}

extension SearchClient {
    static let live = SearchClient(users: {
        $0.publisher
            .receive(on: $0.scheduler)
            .eraseToEffect()
    })
}


struct SearchRequest: APIRequest {
    /// リクエスト
    let request: SearchUserRequest
    /// ボディ
    typealias Body = SearchUserRequest
    /// レスポンス
    typealias Response = SearchUserResponse.Users
    /// メソッド
    var method: HTTPMethodType { .get }
    /// パス
    var path: String { "/search/users" }
    /// パブリッシャー
    var publisher: AnyPublisher<SearchUserResponse.Users, APIError> {
        request(body: request)
    }
}
