//
//  PokePrototype.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 10..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

class PMPokePrototype: Codable {
  
  var id: String?
  var userId: String
  var message: String
  var responses: [String]
  
  init(userId: String, message: String, responses: [String]) {
    self.userId = userId
    self.message = message
    self.responses = responses
  }
  
}
