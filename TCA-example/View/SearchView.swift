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
    var users: Users? = Users()
    var searchQuery: String = ""
}

enum Action: Equatable {
    case searchQueryChanged(String)
    case response(Result<Users, Failure>)
}

struct Environment {
    var usersClient: UsersClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - Search feature reducer

let reducer = Reducer<State, Action, Environment> { state, action, environment in
    switch action {
    case let .searchQueryChanged(value):
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
        
    case .response(.failure):
        state.users = nil
        return .none
        
    case let .response(.success(response)):
        state.users = response
        return .none
    }
}

// MARK: - Search view

struct SearchView: View {
    let store: Store<State, Action>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            // TODO: UI
        }
    }
}
