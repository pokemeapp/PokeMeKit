//
//  PMUser.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 09. 27..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMUser: PMAPIEntity {
  
  public var id: String?
  public var email: String
  public var firstName: String
  public var lastName: String
  public var password: String?
  public var pokes: [String] = []
  public var localReminders: [String] = []
  public var friends: [String] = []
  
  public init(email: String, firstName: String, lastName: String) {
    
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    
  }
  
}
