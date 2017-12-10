//
//  PMAPIRequestFactory.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 11. 01..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMAPIRequestFactory: PMAPIRequestFactoryProtocol {
  
  private let encoder = JSONEncoder()
  
  public init() {
    
  }
  
  public func make<Entity>(baseURL: URL, route: String, query: [String: String]?, method: PMAPIMethod, content: Entity? = nil) -> URLRequest where Entity: PMAPIEntity {

    var url = baseURL.appendingPathComponent(route)

    if let query = query {
      var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
      components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
      url = components.url!
    }

    var request = URLRequest(url: url)
    if let entity = content, let entityData = try? encoder.encode(entity) {
      request.httpBody = entityData
    }
    
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    return request
  }

}
