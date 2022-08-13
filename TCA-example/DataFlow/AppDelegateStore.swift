//
//  AppDelegateStore.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

// MARK: Push通知, 起動後の処理を管理するためのStore

struct AppDelegateState: Equatable {}

enum AppDelegateAction {
    case onLaunchFinish
}

struct AppDelegateEnvironment {}

let appDelegateReducer = Reducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment>
    .combine(
    .init { _, action, environment in
        switch action {
        case .onLaunchFinish:
            return .none
        }
    }
)
