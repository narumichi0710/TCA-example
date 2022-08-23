//
//  SearchMainScreen.swift
//

import SwiftUI
import ComposableArchitecture
import Combine


/// ユーザー検索画面
struct SearchMainScreen: View {
    let store: Store<SearchStore.State, SearchStore.Action>
    
    var body: some View {
        ZStack {
            WithViewStore(store) { viewStore in
                // ナビゲーション
                navigationLink(viewStore)
                // コンテント
                content(viewStore)
            }
        }
    }
    
    /// ナビゲーション
    private func navigationLink(_ viewStore: ViewStore<SearchStore.State, SearchStore.Action>) -> some View {
        NavigationLink("", isActive: viewStore.binding(
            get: \.selectedUser.flag,
            send: SearchStore.Action.presentRepositories(nil)
        )){
            RepositoriesMainScreen(
                selectedUser: viewStore.binding(
                    get: \.selectedUser,
                    send: SearchStore.Action.presentRepositories(nil)
                )
            ).navigationBarHidden(true)
        }
    }
    
    /// コンテント
    private func content(_ viewStore: ViewStore<SearchStore.State, SearchStore.Action>) -> some View {
        VStack {
            // ヘッダー
            Text("Github User 絞り込み画面")
                .font(.title)
            
            // 検索項目
            TextField(
                "user name",
                text: viewStore.binding(
                    get: \.searchdWord, send: SearchStore.Action.changedSearchWord
                )
            )
                .onChange(of: viewStore.searchdWord) { _ in
                    // searchQuery変更時にStoreに対してActionを発行. 副作用を発生させる.
                    viewStore.send(.changedSearchWord(viewStore.searchdWord))
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.asciiCapable)
                .padding()
            
            Spacer()
            
            // 検索結果リスト
            if let items = viewStore.users?.items {
                ScrollView {
                    VStack {
                        ForEach(items) { user in
                            UserCell(user: user)
                                .onTapGesture {
                                    viewStore.send(.presentRepositories(user))
                                }
                            Divider()
                        }
                    }
                }
            } else {
                Text("検索ワードに一致するユーザーが存在しません。")
            }
        }
    }
}
