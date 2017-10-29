//
//  PMUserSpec.swift
//  PokeMeKitTests
//
//  Created by Simkó Viktor on 2017. 09. 27..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Quick
import Nimble
@testable import PokeMeKit

class PMUserSpec: QuickSpec {
  
  override func spec() {
    
    let id = "1"
    let username = "user123"
    let email = "user123@testmail.com"
    let firstName = "user1"
    let lastName = "23"
    let pokes = ["1", "2", "3"]
    let localReminders = ["1", "2", "3"]
    let friends = ["100", "101", "102"]
    
    describe("PMUser") {
      
      it("should be decodable from JSON") {
        let userJSON = """
          {
            "id": "1",
            "username": "user123",
            "email": "user123@testmail.com",
            "firstName": "user1",
            "lastName": "23",
            "pokes": ["1", "2", "3"],
            "localReminders": ["1", "2", "3"],
            "friends": ["100", "101", "102"]
          }
        """
        
        let userJSONData = Data(bytes: [UInt8](userJSON.utf8))
        
        let decoder = JSONDecoder()
        
        let user = try! decoder.decode(PMUser.self, from: userJSONData)
        
        expect(user.id).to(equal(id))
        expect(user.username).to(equal(username))
        expect(user.email).to(equal(email))
        expect(user.firstName).to(equal(firstName))
        expect(user.lastName).to(equal(lastName))
        expect(user.pokes).to(equal(pokes))
        expect(user.localReminders).to(equal(localReminders))
        expect(user.friends).to(equal(friends))
      }
      
      it("should be encodable to json") {
        
        let user = PMUser(username: username, email: email, firstName: firstName, lastName: lastName)
        user.id = id
        user.pokes = pokes
        user.localReminders = localReminders
        user.friends = friends
        
        let encoder = JSONEncoder()
        
        let dataFromUser = try! encoder.encode(user)
        let stringFromUser = String(data: dataFromUser, encoding: .utf8)!
        
        let idRange = stringFromUser.range(of: "\"id\":\"\(id)\"")
        let userNameRange = stringFromUser.range(of: "\"username\":\"\(username)\"")
        let emailRange = stringFromUser.range(of: "\"email\":\"\(email)\"")
        let firstNameRange = stringFromUser.range(of: "\"firstName\":\"\(firstName)\"")
        let lastNameRange = stringFromUser.range(of: "\"lastName\":\"\(lastName)\"")
        let pokesRange = stringFromUser.range(of: "\"pokes\":\(pokes)".replacingOccurrences(of: " ", with: ""))
        let localRemindersRange = stringFromUser.range(of: "\"localReminders\":\(localReminders)".replacingOccurrences(of: " ", with: ""))
        let friendsRange = stringFromUser.range(of: "\"friends\":\(friends)".replacingOccurrences(of: " ", with: ""))
        
        expect(idRange).toNot(beNil())
        expect(userNameRange).toNot(beNil())
        expect(emailRange).toNot(beNil())
        expect(firstNameRange).toNot(beNil())
        expect(lastNameRange).toNot(beNil())
        expect(pokesRange).toNot(beNil())
        expect(localRemindersRange).toNot(beNil())
        expect(friendsRange).toNot(beNil())
        
      }
      
    }
    
    describe("init(username:email:firstName:lastName:)") {
      
      it("should initialize the members to the given values") {
        
        let user = PMUser(username: username, email: email, firstName: firstName, lastName: lastName)
        
        expect(user.username).to(equal(username))
        expect(user.email).to(equal(email))
        expect(user.firstName).to(equal(firstName))
        expect(user.lastName).to(equal(lastName))
        
      }
      
    }
    
  }
  
}
