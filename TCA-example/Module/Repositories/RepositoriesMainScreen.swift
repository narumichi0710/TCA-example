//
//  RepositoriesMainScreen.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/13.
//

import SwiftUI
import ComposableArchitecture

struct RepositoriesMainScreen: View {
    /// 選択中のユーザー
    @Binding var selectedUser: Bindable<SearchUserResponse.User>
    
    var body: some View {
        VStack{
            content
        }
    }
    
    /// コンテント
    private var content: some View {
        VStack {
            // ヘッダー
            HStack {
                Button("戻る") {
                    selectedUser = Bindable<SearchUserResponse.User>(nil)
                }
                Spacer()
            }
            .padding()
            
            if let selectedUser = selectedUser.item {
                // ユーザーセル
                UserCell(user: selectedUser)
                    .background(.green)
                
                // レポジトリ一覧
                Text("TODO:")
            }
            Spacer()
        }
        
    }
}
