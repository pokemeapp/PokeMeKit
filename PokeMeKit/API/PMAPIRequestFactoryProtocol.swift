//
//  PMAPIRequestFactory.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 30..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public enum PMAPIMethod: String {
  case GET = "GET"
  case POST = "POST"
}

public protocol PMAPIRequestFactoryProtocol {

  func make<Entity>(baseURL: URL, route: PMAPI.Route, method: PMAPIMethod, content: Entity?) -> URLRequest where Entity: PMAPIEntity
  
}

