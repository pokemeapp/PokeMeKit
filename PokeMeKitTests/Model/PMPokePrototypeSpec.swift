//
//  PMPokePrototypeSpec.swift
//  PokeMeKitTests
//
//  Created by Simkó Viktor on 2017. 10. 04..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Quick
import Nimble
@testable import PokeMeKit

class PMPokePrototypeSpec: QuickSpec {
  
  override func spec() {
    
    let id = "1"
    let userId = "2"
    let message = "Some message."
    let responses = ["response1", "response2", "response3"]
    
    describe("PMPokePrototype") {
      
      it("should be decodable from JSON") {
        let pokePrototypeJSON = """
          {
            "id": "1",
            "userId": "2",
            "message": "Some message.",
            "responses": ["response1", "response2", "response3"]
          }
        """
        
        let pokePrototypeJSONData = Data(bytes: [UInt8](pokePrototypeJSON.utf8))
        
        let decoder = JSONDecoder()
        
        let pokePrototype = try! decoder.decode(PMPokePrototype.self, from: pokePrototypeJSONData)
        
        expect(pokePrototype.id).to(equal(id))
        expect(pokePrototype.userId).to(equal(userId))
        expect(pokePrototype.message).to(equal(message))
        expect(pokePrototype.responses).to(equal(responses))
      }
      
      it("should be encodable to json") {

        let pokePokePrototype = PMPokePrototype(userId: userId, message: message, responses: responses)
        pokePokePrototype.id = id

        let encoder = JSONEncoder()

        let dataFromPokePrototype = try! encoder.encode(pokePokePrototype)
        let stringFromUser = String(data: dataFromPokePrototype, encoding: .utf8)!

        let idRange = stringFromUser.range(of: "\"id\":\"\(id)\"")
        let userIdRange = stringFromUser.range(of: "\"userId\":\"\(userId)\"")
        let messageRange = stringFromUser.range(of: "\"message\":\"\(message)\"")
        let responsesRange = stringFromUser.range(of: "\"responses\":\(responses)".replacingOccurrences(of: " ", with: ""))

        expect(idRange).toNot(beNil())
        expect(userIdRange).toNot(beNil())
        expect(messageRange).toNot(beNil())
        expect(responsesRange).toNot(beNil())

      }
      
    }

    describe("init(username:email:firstName:lastName:)") {

      it("should initialize the members to the given values") {

        let pokePrototype = PMPokePrototype(userId: userId, message: message, responses: responses)

        expect(pokePrototype.userId).to(equal(userId))
        expect(pokePrototype.message).to(equal(message))
        expect(pokePrototype.responses).to(equal(responses))

      }

    }
    
  }
  
}
