//
//  PMUser.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 09. 27..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMUser: PMAPIEntity {
  
  var id: String?
  var email: String
  var firstName: String
  var lastName: String
  var password: String?
  var pokes: [String] = []
  var localReminders: [String] = []
  var friends: [String] = []
  
  public init(email: String, firstName: String, lastName: String) {
    
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    
  }
  
}
