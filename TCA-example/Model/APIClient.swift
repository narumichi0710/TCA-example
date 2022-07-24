//
//  APIClient.swift
//  TCA-example
//
//  Created by Narumichi Kubo on 2022/07/24.
//

import Foundation
import ComposableArchitecture

// MARK: - API client interface

struct UsersClient {
    var users: (String) -> Effect<Users, Failure>
}

// MARK: - Live API implementation

extension UsersClient {
    static let live =  UsersClient(users: { query in

        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/users"
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        
        return URLSession.shared.dataTaskPublisher(for: components.url!)
          .map { data, _ in data }
          .decode(type: Users.self, decoder: JSONDecoder())
          .mapError { _ in Failure() }
          .eraseToEffect()
    })
   
}


// MARK: - API Error localizedDescription

struct Failure: Error, Equatable {
    // TODO:
}
