//
// Created by Simkó Viktor on 2017. 12. 12..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public class PMPoke: PMAPIEntity {

  public init() {}

  public var id: Int?
  public var prototype_id: Int?
  public var owner_id: Int?
  public var target_id: Int?
  public var response: String?
  public var prototype: PMPokePrototype?

}

