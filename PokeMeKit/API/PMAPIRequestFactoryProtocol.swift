//
//  PMAPIRequestFactory.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 30..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

enum PMAPIMethod: String {
  case GET = "GET"
  case POST = "POST"
}

protocol PMAPIRequestFactoryProtocol {

  func make(baseURL: URL, route: PMAPI.Route, method: PMAPIMethod, content: PMAPIEntity?) -> URLRequest
  
}

