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
  
  public func make<Entity>(baseURL: URL, route: PMAPI.Route, method: PMAPIMethod, content: Entity? = nil) -> URLRequest where Entity: PMAPIEntity {
    
    let url = baseURL.appendingPathComponent(route.rawValue)
    var request = URLRequest(url: url)
    if let entity = content, let entityData = try? encoder.encode(entity) {
      request.httpBody = entityData
    }
    
    return request
  }

}
