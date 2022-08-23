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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView(store: appDelegate.store)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store(
        initialState: AppStore.State(),
        reducer: AppStore.reducer,
        environment: AppStore.Environment(
            searchEnv: .init(searchClient: .live)
        )
    )
    
    lazy var viewStore = ViewStore(store)

    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // アプリ起動処理
        viewStore.send(.appDelegate(.onLaunchFinish))
        
        print("yobaremasita")
        return true
    }
}
