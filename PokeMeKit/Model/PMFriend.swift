//
//  PMFriend.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 11. 30..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMFriend: PMAPIEntity {
  
  public var id: Int?
  public var userId: Int
  public var friendId: Int
  public var owner: PMUser?
  
  private enum CodingKeys: String, CodingKey {
    
    case id, userId = "user_id", friendId = "friend_id", owner
    
  }
  
}
