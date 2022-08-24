//
//  SearchStore.swift
//
import Foundation
import ComposableArchitecture
import Combine

// MARK: 検索機能 Store
enum SearchStore {
    struct State: Equatable {
        /// パブリッシャーキャンセル用のHash値.
        struct CancelID: Hashable {
            let id = String(describing: State.self)
        }
        /// ユーザー一覧
        var users: SearchUserResponse.Users? = nil
        /// 検索ワード
        var searchdWord: String = ""
        /// 選択中のユーザー
        var selectedUser: Bindable = Bindable<SearchUserResponse.User>(nil)
        /// エラーステータス
        var errorStatus: Bindable<String> = Bindable(nil)
    }
    
    enum Action: Equatable {
        /// ユーザー一覧取得アクション
        case response(Result<SearchUserResponse.Users, APIError>)
        /// ユーザー一覧取得アクション
        case getContent
        /// 絞り込みワード変更アクション
        case changedSearchWord(String)
        /// リポジトリ画面遷移アクション
        case presentRepositories(SearchUserResponse.User?)
    }
    
    struct Environment {
        /// ユーザー検索クライアント
        let searchClient: SearchClient
    }
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .response(let result):
            switch result {
            case .success(let response):
                // ユーザー一覧取得 成功処理
                state.users = response
                return .none

            case .failure(let error):
                state.errorStatus = Bindable(error.localize)
                return .none
            }
        case .getContent:
            // 検索処理
            return environment.searchClient
                .users(
                    .init(request: SearchUserRequest(q: state.searchdWord))
                )
                .catchToEffect(Action.response)
                .cancellable(id: State.CancelID())
            
        case .changedSearchWord(let searchdWord):
            // 検索ワード変更処理
            state.searchdWord = searchdWord
            return .init(value: .getContent)
            
        case .presentRepositories(let selectedUser):
            // レポジトリ画面遷移処理.
            if selectedUser == nil {
                state.selectedUser = Bindable<SearchUserResponse.User>(nil)
            } else {
                state.selectedUser = Bindable<SearchUserResponse.User>(selectedUser)
            }
            return .none
        }
    }
}
