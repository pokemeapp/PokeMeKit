//
//  PokePrototype.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 10..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMPokePrototype: PMAPIEntity {
  
  public var id: Int?
  public var owner_id: Int?
  public var name: String
  public var message: String

  public init(name: String, message: String) {
    self.name = name
    self.message = message
  }
  
}
