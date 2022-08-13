//
//  SearchView.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/23.
//

import SwiftUI
import ComposableArchitecture
import Combine


/// ユーザー検索画面
struct UsersMainScreen: View {
    let store: Store<UsersStore.State, UsersStore.Action>
    
    var body: some View {
        ZStack {
            WithViewStore(store) { viewStore in
                // ナビゲーション
                navigation(viewStore)
                // コンテント
                content(viewStore)
                // エラー
                error
                
            }
        }
        
    }
    
    /// ナビゲーション
    private func navigation(_ viewStore: ViewStore<UsersStore.State, UsersStore.Action>) -> some View {
        NavigationLink("", isActive: viewStore.binding(
            get: \.selectedUser.isSelected,
            send: UsersStore.Action.presentRepositories(nil)
        )){
            RepositoriesMainScreen(
                selectedUser: viewStore.binding(
                    get: \.selectedUser,
                    send: UsersStore.Action.presentRepositories(nil)
                )
            ).navigationBarHidden(true)
        }
    }
    
    /// コンテント
    private func content(_ viewStore: ViewStore<UsersStore.State, UsersStore.Action>) -> some View {
        VStack {
            // ヘッダー
            Text("Github User 絞り込み画面")
                .font(.title)
            
            // 検索項目
            TextField(
                "user name",
                text: viewStore.binding(
                    get: \.filteredWord, send: UsersStore.Action.changedFilterWord
                )
            )
                .onChange(of: viewStore.filteredWord) { _ in
                    // searchQuery変更時にStoreに対してActionを発行. 副作用を発生させる.
                    viewStore.send(.changedFilterWord(viewStore.filteredWord))
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.asciiCapable)
                .padding()
            
            Spacer()
            
            // 検索結果リスト
            if let items = viewStore.filteredUsers {
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
    
    /// エラー
    private var error: some View {
        
        Text("TODO error")
        
    }
    
}
