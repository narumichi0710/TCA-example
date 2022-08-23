//
//  RootView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/12.
//

import SwiftUI
import ComposableArchitecture


struct RootView: View {
    let store: Store<AppStore.State, AppStore.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { geo in
                NavigationView {
                    VStack {
                        // ログイン画面
                        switch viewStore.selectedRootTab {
                        case .users:
                            // 検索画面
                            SearchMainScreen(
                                store: store.scope(
                                    state: \.searchState,
                                    action: AppStore.Action.users
                                )
                            )
                        case .search:
                            VStack {
                                Spacer()
                                Color.green
                                Text("sample2")
                                Spacer()
                            }
                        case .myPage:
                            VStack {
                                Spacer()
                                Color.green
                                Text("sample3")
                                Spacer()
                            }
                            
                        }
                        // タブバー
                        tabBar(
                            viewStore: viewStore,
                            tabItemWidth: geo.size.width / CGFloat(AppStore.RootTabType.allCases.count)
                        )
                    }
                    .navigationBarHidden(true)
                    .onAppear {
                        // ユーザー一覧の取得
                        viewStore.send(.users(.getContent))
                    }
                }
            }
        }
    }
    
    /// タブ変更バー.
    private func tabBar(
        viewStore: ViewStore<AppStore.State, AppStore.Action>,
        tabItemWidth: CGFloat
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(AppStore.RootTabType.allCases, id: \.self) { type in
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
