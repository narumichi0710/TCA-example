//
//  AppStore.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリ全体で管理するためのStore
enum AppStore {
    struct State: Equatable {
        /// appDeregate State
        var appDelegateState = AppDelegateStore.State()
        /// ルートタブの状態を管理しているState
        var selectedRootTab: RootTabType = .users
        /// ユーザー機能の状態を管理しているState
        var usersState = UsersStore.State()
    }
    
    enum Action: BindableAction {
        /// ルートなどのアクション
        case binding(BindingAction<State>)
        ///  push通知, スプラッシュ機能などのアクション
        case appDelegate(AppDelegateStore.Action)
        /// ルートタブ変更アクション
        case changedRootTab(RootTabType)
        /// ユーザー機能アクション
        case users(UsersStore.Action)
    }
    
    struct Environment {
        /// ユーザークライアント
        let usersClient: UsersClient
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
        case .binding(_):
            return .none
        case .appDelegate(_):
            return .none
        case .users(.changedFilterWord(let type)):
            return .none
        case .changedRootTab(let type):
            // タブの更新処理
            state.selectedRootTab = type
            return .none
        case .users(.response(_)):
            return .none
        case .users(.getContent):
            return .none
        case .users(.presentRepositories(_)):
            return .none
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
        UsersStore.reducer.pullback(
            state: \State.usersState,
            action: /Action.users,
            environment: { 
                .init(usersClient: $0.usersClient)
            }
        )
    )
}
