//
//  TCA_exampleApp.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/23.
//

import SwiftUI
import ComposableArchitecture


@main
struct TCA_exampleApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(store: Store(
                initialState: State(),
                reducer: reducer,
                environment: Environment(
                    usersClient: UsersClient.live,
                    mainQueue: .main
                )
            ))
        }
    }
}
