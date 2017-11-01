//
//  PokePrototype.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 10..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMPokePrototype: Codable {
  
  public var id: String?
  public var userId: String
  public var message: String
  public var responses: [String]
  
  public init(userId: String, message: String, responses: [String]) {
    self.userId = userId
    self.message = message
    self.responses = responses
  }
  
}
