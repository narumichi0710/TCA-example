//
//  RootView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture


/// タブタイプ
enum RootTabType: String, CaseIterable {
    case users
    case search
    case myPage
}

struct RootView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject private var viewStore: ViewStore<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        viewStore = ViewStore(store)
        
        print("fmofdkgdf")
        // 一覧の取得
        viewStore.send(.users(.getContent))
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                // ログイン画面
                switch viewStore.selectedRootTab {
                case .users:
                    // トップ画面
                    UsersMainScreen(
                        store: store.scope(
                            state: \.usersState,
                            action: AppAction.users
                        )
                    )
                  
                case .search:
                    // 検索画面
                    SearchMainScreen(
                        store: store.scope(
                            state: \.usersState,
                            action: AppAction.users
                        )
                    )
                case .myPage:
                    // マイページ
                    VStack {
                        Spacer()
                        Color.green
                        Text("マイページ")
                        Spacer()
                    }
                    
                }
                
                // タブバー
                tabBar(tabItemWidth: geo.size.width / CGFloat(RootTabType.allCases.count))
            }
        }
        .onAppear {
            
        }
    }
    
    
    /// タブ変更バー.
    private func tabBar(tabItemWidth: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(RootTabType.allCases, id: \.self) { type in
                    Button {
                        viewStore.send(.changedRootTab(type), animation: .default)
                    } label: {
                        Text(type.rawValue)
                    }
                    .frame(width: tabItemWidth)
                }
                Spacer()
            }
            .frame(height: 40)
        }
    }
}
