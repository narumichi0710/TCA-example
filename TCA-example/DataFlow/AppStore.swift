//
//  AppStore.swift
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリコア Store
enum AppStore {
    struct State: Equatable {
        /// appDeregate State
        var appDelegateState = AppDelegateStore.State()
        /// ルートタブの状態を管理しているState
        var selectedRootTab: RootTabType = .users
        /// ユーザー機能の状態を管理しているState
        var usersState = SearchStore.State()
    }
    
    enum Action: Equatable {
        ///  push通知, スプラッシュ機能などのアクション
        case appDelegate(AppDelegateStore.Action)
        /// ルートタブ変更アクション
        case changedRootTab(RootTabType)
        /// ユーザー機能アクション
        case users(SearchStore.Action)
    }
    
    struct Environment {
        /// ユーザークライアント
        let usersClient: SearchClient
    }
    
    /// ルートタブタイプ
    enum RootTabType: String, CaseIterable {
        case users
        case search
        case myPage
    }
    /// アプリ全体で管理している状態の変更処理を行うためのReducer.
    /// アクションで2つ以上になる場合はReducerを分割する.
    static let coreReducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .changedRootTab(let type):
            // タブの更新処理
            state.selectedRootTab = type
            return .none
        default: return .none
        }
    }
    
    /// appCoreReducer, 分割したReducerを統合して監視するためのReducer.
    static let reducer = Reducer<State, Action, Environment>.combine(
        // アプリコアReducer
        coreReducer,
        // AppderegateReducer
        AppDelegateStore.reducer.pullback(
            state: \State.appDelegateState,
            action: /Action.appDelegate,
            environment: { _ in .init() }),
        // ユーザー機能Reducer
        SearchStore.reducer.pullback(
            state: \State.usersState,
            action: /Action.users,
            environment: {
                .init(usersClient: $0.usersClient)
            }
        )
    )
}
