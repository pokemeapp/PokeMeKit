//
//  PMAPIRequestFactorySpec.swift
//  PokeMeKitTests
//
//  Created by Simkó Viktor on 2017. 11. 01..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Quick
import Nimble
@testable import PokeMeKit

class PMAPIRequestFactorySpec: QuickSpec {

  override func spec() {
    
    describe("make") {
      
      it("should make a request with the given properties") {
        let apiRequestFactory = PMAPIRequestFactory()
        
        let url = URL(string: "http://www.pokeme.com")!
        let user = PMUser(email: "user@usermail.com", firstName: "Test", lastName: "Tory")
        let encoder = JSONEncoder()
        let userData = try! encoder.encode(user)
        
        let request = apiRequestFactory.make(baseURL: url, route: .register, method: .GET, content: user)
        
        expect(request.url).to(equal(URL(string: "http://www.pokeme.com/api/register")))
        expect(request.httpMethod).to(equal("GET"))
        expect(request.httpBody).to(equal(userData))
      }
      
    }
    
  }
  
}


