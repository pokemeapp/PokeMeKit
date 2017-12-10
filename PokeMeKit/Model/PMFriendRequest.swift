//
// Created by Simkó Viktor on 2017. 12. 09..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public class PMFriendRequest: PMAPIEntity {

  public init() {}

  public var id: Int?
  public var owner_id: Int?
  public var target_id: Int?
  public var status: Int?
  public var owner: PMUser?

}
