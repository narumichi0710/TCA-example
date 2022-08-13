//
//  AppDelegateStore.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture

// MARK: Push通知, 起動後の処理を管理するためのStore
enum AppDelegateStore {
    
    struct State: Equatable {}
    
    enum Action {
        case onLaunchFinish
    }
    
    struct Environment {}
    
    static let reducer = Reducer<State, Action, Environment>
        .combine(
            .init { _, action, environment in
                switch action {
                case .onLaunchFinish:
                    return .none
                }
            }
        )
}
