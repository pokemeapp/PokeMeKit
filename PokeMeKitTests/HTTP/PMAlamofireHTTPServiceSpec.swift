//
//  PMAlamofireHTTPServiceSpec..swift
//  PokeMeKitTests
//
//  Created by Simkó Viktor on 2017. 11. 01..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import PokeMeKit

class PMAlamofireHTTPServiceSpec: QuickSpec {
  
  override func spec() {
    
    describe("request") {
      
      let alamofireHTTPService = PMAlamofireHTTPService()
      
      let request = URLRequest(url: URL(string: "http://www.pokeme.com")!)

      it("should forward the error from Alamofire") {
        
        enum DummyError: Error {
          case dummy
        }
        
        stub(condition: isHost("www.pokeme.com")) { request in
          
          return OHHTTPStubsResponse(error: DummyError.dummy)
          
        }

        waitUntil { done in
          alamofireHTTPService.request(request) { error, response, data in
            expect(error as? DummyError).to(equal(DummyError.dummy))
            done()
          }
        }

      }
      
      it("should forward the response from Alamofire") {
        stub(condition: isHost("www.pokeme.com")) { request in
          
          return OHHTTPStubsResponse(fileURL: URL(string: "http://www.pokeme.com")!, statusCode: 200, headers: ["Content-Type": "application/json"])
          
        }
        
        waitUntil { done in
          alamofireHTTPService.request(request) { error, response, data in
            expect(response?.url).to(equal(URL(string: "http://www.pokeme.com")))
            expect(response?.statusCode).to(equal(200))
            expect(response?.allHeaderFields["Content-Type"] as? String).to(equal("application/json"))
            done()
          }
        }
      }
      
      it("should forward the data from Alamofire") {
        let responseData = Data(bytes: [UInt8]("some data".utf8))
        
        stub(condition: isHost("www.pokeme.com")) { request in
          
          return OHHTTPStubsResponse(data: responseData, statusCode: 200, headers: nil)

        }
        
        waitUntil { done in
          alamofireHTTPService.request(request) { error, response, data in
            expect(data).to(equal(responseData))
            done()
          }
        }
      }
      
    }
    
  }
  
}
