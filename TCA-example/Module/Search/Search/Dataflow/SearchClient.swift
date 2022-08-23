//
//  SearchClient.swift
//

import Foundation
import ComposableArchitecture


struct SearchClient {
    var users: (String) -> Effect<Users, Failure>
}


extension SearchClient {
    static let live =  SearchClient(users: { query in

        
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
