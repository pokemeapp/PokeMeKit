//
//  PMUser.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 09. 27..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMUser: PMAPIEntity {
  
  public var id: Int?
  public var email: String?
  public var firstname: String
  public var lastname: String
  public var password: String?
  public var pokes: [String]? = []
  public var localReminders: [String]? = []
  public var friends: [String]? = []
  
  public init(email: String, firstname: String, lastname: String) {
    
    self.email = email
    self.firstname = firstname
    self.lastname = lastname
    
  }
  
}
