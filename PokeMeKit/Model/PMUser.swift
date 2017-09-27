//
//  PMUser.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 09. 27..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

class PMUser: Decodable {
  
  var id: String?
  var username: String
  var email: String
  var firstName: String
  var lastName: String
  var pokes: [String]?
  var localReminders: [String]?
  var friends: [String]?
  
  init(username: String, email: String, firstName: String, lastName: String) {
    
    self.username = username
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    
  }
  
}
