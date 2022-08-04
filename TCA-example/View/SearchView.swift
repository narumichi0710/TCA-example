//
//  SearchView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/23.
//

import SwiftUI
import ComposableArchitecture
import Combine

// MARK: - Users feature domain

struct State: Equatable {
    /// ユーザー一覧
    var users: Users? = Users()
    /// 検索ワード
    var searchQuery: String = ""
    /// 選択中のユーザー
    var selectedUser: Users.User? = nil
}

enum Action: Equatable {
    /// ユーザー一覧取得アクション
    case response(Result<Users, Failure>)
    /// テキスト変更アクション
    case searchQueryChanged(String)
    /// 選択中ユーザー変更アクション
    case changeSelectedUser(Users.User?)
}

struct Environment {
    /// ユーザー一覧API Client
    var usersClient: UsersClient
    /// スケジューラー
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Search feature reducer
let reducer = Reducer<State, Action, Environment> { state, action, environment in
    switch action {
    case .response(.failure):
        // ユーザー一覧取得 失敗処理
        state.users = nil
        return .none
        
    case let .response(.success(response)):
        // ユーザー一覧取得 成功処理
        state.users = response
        return .none
    case let .searchQueryChanged(value):
        // テキスト変更処理
        enum SearchLocationId {}
        
        state.searchQuery = value
        
        guard !value.isEmpty else {
            state.users = nil
            return .cancel(id: SearchLocationId.self)
        }
        return environment.usersClient
            .users(value)
        // イベントを保持し、一定時間イベントのアップデートがなければその時点の最新値を送信する
            .debounce(
                id: SearchLocationId.self,
                for: 0.3,
                scheduler: environment.mainQueue
            )
        // レスポンスの値をActionに返却する
            .catchToEffect(Action.response)
        
    case let .changeSelectedUser(value):
        ///ユーザー一覧セル押下処理
        state.selectedUser = value
        return .none
    }
}

// MARK: - Search view
/// ユーザー検索画面
struct SearchView: View {
    let store: Store<State, Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                // コンテント
                content(viewStore)
                // エラー
                error
            }
            // ユーザーレポジトリ一覧モーダルを表示
            .fullScreenCover(item: viewStore.binding(
                get: \.selectedUser, send: Action.changeSelectedUser
            )){ _ in
                Text("TODO:")
            }

        }
    }
    
    
    /// コンテント
    private func content(_ viewStore: ViewStore<State, Action>) -> some View {
        VStack {
            // ヘッダー
            Text("🔍Search Github User")
                .font(.title)
            
            // 検索項目
            TextField(
                "user name",
                text: viewStore.binding(
                    get: \.searchQuery, send: Action.searchQueryChanged
                )
            )
                .onChange(of: viewStore.searchQuery) { _ in
                    // searchQuery変更時にStoreに対してActionを発行. 副作用を発生させる.
                    viewStore.send(.searchQueryChanged(viewStore.searchQuery))
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.asciiCapable)
                .padding()
            
            Spacer()
            
            // 検索結果リスト
            if let items = viewStore.users?.items {
                List(items) { user in
                    UserCell(user: user)
                        .onTapGesture {
                            viewStore.send(.changeSelectedUser(user))
                        }
                }
                .refreshable {
                    viewStore.send(.searchQueryChanged(viewStore.searchQuery))
                }
            }
        }
    }
    
    /// エラー
    private var error: some View {
        Text("TODO: error")
    }
    
}

/// ユーザー検索結果セル
struct UserCell: View {
    let user: Users.User
    
    var body: some View {
        HStack {
            if let avatarUrl = user.avatarUrl {
                AsyncImage(url: URL(string: avatarUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding()
            }
            Spacer()
            if let login = user.login {
                Text(login)
                    .padding()
            }
            Spacer()
        }
    }
}
