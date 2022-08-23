//
//  SearchStore.swift
//
import Foundation
import ComposableArchitecture
import Combine

// MARK: 検索機能 Store
enum SearchStore {
    struct State: Equatable {
        /// ユーザー一覧
        var users: Users? = nil
        /// 絞り込みユーザー一覧
        var filteredUsers: [User]? = nil
        /// 検索ワード
        var filteredWord: String = ""
        /// 選択中のユーザー
        var selectedUser: Selection = Selection<User>(nil)
    }
    
    enum Action: Equatable {
        /// ユーザー一覧取得アクション
        case response(Result<Users, Failure>)
        /// 絞り込みワード変更アクション
        case changedFilterWord(String)
        /// ユーザー一覧取得アクション
        case getContent
        /// リポジトリ画面遷移アクション
        case presentRepositories(User?)
    }
    
    static let reducer = Reducer<State, Action, AppStore.Environment> { state, action, environment in
        switch action {
        case .response(.failure):
            // ユーザー一覧取得 失敗処理
            // TODO: アラート表示
            
            return .none
            
        case let .response(.success(response)):
            // ユーザー一覧取得 成功処理
            state.users = response
            
            if let users = state.users?.items {
                state.filteredUsers = users
            }
            
            return .none
            
        case .changedFilterWord(let inputData):
            // 入力情報の更新
            state.filteredWord = inputData
            
            // 入力値が空の場合、初期値を入れる
            if inputData.isEmpty {
                state.filteredUsers = state.users?.items
                return .none
            }
            
            // 絞り込みを行う
            state.filteredUsers = state.users?.items.filter { user in
                user.login.contains(state.filteredWord)
            }
            
            return .none
            
        case .getContent:
            
            // 検索処理
            enum SearchLocationId {}
            
            return environment.usersClient
                .users("aaa")
            // イベントを保持し、一定時間イベントのアップデートがなければその時点の最新値を送信する
                .debounce(
                    id: SearchLocationId.self,
                    for: 0.3,
                    scheduler: DispatchQueue.main
                )
            // レスポンスの値をActionに返却する
                .catchToEffect(Action.response)
        case .presentRepositories(let selectedUser):
            // レポジトリ画面遷移処理.
            if selectedUser == nil {
                state.selectedUser = Selection<User>(nil)
            } else {
                state.selectedUser = Selection<User>(selectedUser)
            }
            return .none
        }
    }
}


/// ナビゲーションの引数として利用するための構造体
struct Selection<T>: Equatable {
    /// isActiveフラグのBinding先として定義
    var isSelected: Bool = false
    /// 選択中のアイテム
    var selectdItem: T?
    
    init(_ item: T?) {
        isSelected = item != nil
        selectdItem = item
    }
    
    static func == (lhs: Selection<T>, rhs: Selection<T>) -> Bool {
        return lhs.isSelected == rhs.isSelected
    }
}
