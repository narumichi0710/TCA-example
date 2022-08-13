//
//  AppStore.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリ全体で管理しているStore

struct AppState: Equatable {
    /// appDeregate State
    var appDelegateState = AppDelegateState()
    /// ルートタブの状態を管理しているState
    var selectedRootTab: RootTabType = .users
    /// ユーザー機能の状態を管理しているState
    var usersState = UsersState()
}

enum AppAction: BindableAction {
    /// ルートなどのアクション
    case binding(BindingAction<AppState>)
    ///  push通知, スプラッシュ機能などのアクション
    case appDelegate(AppDelegateAction)
    /// ルートタブ変更アクション
    case changedRootTab(RootTabType)
    /// ユーザー機能アクション
    case users(UsersAction)
}

struct AppEnvironment {
    /// ユーザークライアント
    let usersClient: UsersClient
}

/// アプリ全体で管理している状態の変更処理を行うためのReducer.
/// アクションで2つ以上になる場合はReducerを分割する.
let appReducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
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
    }
}

/// appCoreReducer, 分割したReducerを統合して監視するためのReducer.
let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    // アプリコアReducer
    appReducerCore,
    // AppderegateReducer
    appDelegateReducer.pullback(
        state: \.appDelegateState,
        action: /AppAction.appDelegate,
        environment: { _ in .init() }),
    // ユーザー機能Reducer
    usersReducer.pullback(
        state: \.usersState,
        action: /AppAction.users,
        environment: {
            .init(usersClient: $0.usersClient)
        }
    )
)
