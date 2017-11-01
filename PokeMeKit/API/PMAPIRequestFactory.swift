//
//  PMAPIRequestFactory.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 11. 01..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMAPIRequestFactory: PMAPIRequestFactoryProtocol {
  
  public func make(baseURL: URL, route: PMAPI.Route, method: PMAPIMethod, content: PMAPIEntity?) -> URLRequest {
    
    return URLRequest(url: baseURL)
  }

}
