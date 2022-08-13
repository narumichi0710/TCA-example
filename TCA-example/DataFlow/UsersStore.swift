//
//  UsersStore.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import Foundation
import ComposableArchitecture
import Combine

// MARK: ユーザー機能 Store
enum UsersStore {
    struct State: Equatable {
        /// ユーザー一覧
        var users: Users? = nil
        /// 絞り込みユーザー一覧
        var filteredUsers: [User]? = nil
        /// 検索ワード
        var filteredWord: String = ""
    }
    
    enum Action: Equatable {
        /// ユーザー一覧取得アクション
        case response(Result<Users, Failure>)
        /// 絞り込みワード変更アクション
        case changedFilterWord(String)
        /// ユーザー一覧取得アクション
        case getContent
    }
    
    static let reducer = Reducer<State, Action, AppStore.Environment> { state, action, environment in
        switch action {
        case .response(.failure):
            // ユーザー一覧取得 失敗処理
            // TODO: アラート表示
            
            return .none
            
        case let .response(.success(response)):
            // ユーザー一覧取得 成功処理
            state.users = response
            
            if let users = state.users?.items {
                state.filteredUsers = users
            }
            
            return .none
            
        case .changedFilterWord(let inputData):
            // 入力情報の更新
            state.filteredWord = inputData
            
            // 入力値が空の場合、初期値を入れる
            if inputData.isEmpty {
                state.filteredUsers = state.users?.items
                return .none
            }
            
            // 絞り込みを行う
            state.filteredUsers = state.users?.items.filter { user in
                user.login.contains(state.filteredWord)
            }
            
            return .none
            
        case .getContent:
            
            // 検索処理
            enum SearchLocationId {}
            
            return environment.usersClient
                .users("aaa")
            // イベントを保持し、一定時間イベントのアップデートがなければその時点の最新値を送信する
                .debounce(
                    id: SearchLocationId.self,
                    for: 0.3,
                    scheduler: DispatchQueue.main
                )
            // レスポンスの値をActionに返却する
                .catchToEffect(Action.response)
        }
    }
}
