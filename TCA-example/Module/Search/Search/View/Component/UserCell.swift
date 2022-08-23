//
//  UserCell.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/08/10.
//

import SwiftUI

/// ユーザー検索結果セル
struct UserCell: View {
    let user: SearchUserResponse.User
    
    var body: some View {
        HStack {
            if let avatarUrl = user.avatarUrl {
                AsyncImage(url: URL(string: avatarUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding()
            }
            Spacer()
            if let login = user.login {
                Text(login)
                    .padding()
            }
            Spacer()
        }
    }
}
