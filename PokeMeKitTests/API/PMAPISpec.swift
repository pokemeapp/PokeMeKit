//
//  PMAPISpec.swift
//  PokeMeKitTests
//
//  Created by Simkó Viktor on 2017. 10. 30..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Quick
import Nimble
@testable import PokeMeKit

class PMAPISpec: QuickSpec {
  
  class MockAuthManager: PMAuthenticationManager {
    
    func authenticate(email: String, password: String, _ callback: @escaping (PMAPIError?) -> Void) {
      
    }
    
    func authenticate(request: URLRequest) throws -> URLRequest {
      return request
    }

  }
  
  class MockHttpService: PMHTTPService {
    
    func request(_ url: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
      
    }

  }
  
  class MockRequestFactory: PMAPIRequestFactoryProtocol {
    
    func make<Entity>(baseURL: URL, route: PMAPI.Route, method: PMAPIMethod, content: Entity? = nil) -> URLRequest where Entity: PMAPIEntity {
        return URLRequest(url: baseURL)
    }

  }

  override func spec() {
    
    var api: PMAPI!
    var mockAuthService: PMAuthenticationManager!
    var mockHttpService: PMHTTPService!
    var mockRequestFactory: PMAPIRequestFactoryProtocol!
    var baseURL = URL(string: "www.pokeme.com")!
    
    beforeEach {
      mockAuthService = MockAuthManager()
      mockHttpService = MockHttpService()
      mockRequestFactory = MockRequestFactory()
    }
    
    describe("register") {
      let email = "example@testmail.com"
      let firstname = "Test"
      let lastname = "Tory"
      
      let user = PMUser(email: email, firstName: firstname, lastName: lastname)
      
      context("httpService returns an error") {
        enum DummyError: Error {
          case dummy
        }
        
        class ErrorMockHTTPService: PMHTTPService {
          
          func request(_ url: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
            callback(DummyError.dummy, nil, nil)
          }

        }

        it("should forward it") {
          api = PMAPI(authService: mockAuthService, httpService: ErrorMockHTTPService(), requestFactory: mockRequestFactory, baseURL: baseURL)
          
          waitUntil { done in
            api.register(user) { error in
              expect(error as? DummyError).to(equal(DummyError.dummy))
              done()
            }
          }
        }
      }
      
      context("httpService returns a wrong response") {
        
        class WrongResponseMockHTTPService: PMHTTPService {
          
          func request(_ url: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "www.pokeme.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
            callback(nil, response, nil)
          }

        }
        
        it("should return badResponseCode error with the given response code") {
          api = PMAPI(authService: mockAuthService, httpService: WrongResponseMockHTTPService(), requestFactory: mockRequestFactory, baseURL: baseURL)
          
          waitUntil { done in
            api.register(user) { error in
              
              if case let .badResponseCode(code) = error as! PMAPIError {
                expect(code).to(equal(404))
              } else {
                fail("Expected badResponseCode error")
              }
              
              done()
            }
          }
        }
        
      }
      
      context("httpService returns a 400 response") {
        class ValidationErrorResponseMockHTTPService: PMHTTPService {
          
          func request(_ url: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "www.pokeme.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
            callback(nil, response, nil)
          }
          
        }
        
        it("should return validationUnsuccessful error") {
          api = PMAPI(authService: mockAuthService, httpService: ValidationErrorResponseMockHTTPService(), requestFactory: mockRequestFactory, baseURL: baseURL)
          
          waitUntil { done in
            api.register(user) { error in
              if let err = error as? PMAPIError, case .validationUnsuccessful = err { } else {
                fail("Expected validationUnsuccessful error")
              }
              
              done()
            }
          }
        }
      }
      
      context("httpService returns a 201 response") {
        class GoodResponseMockHTTPService: PMHTTPService {
          
          func request(_ url: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
            let response = HTTPURLResponse(url: URL(string: "www.pokeme.com")!, statusCode: 201, httpVersion: nil, headerFields: nil)
            callback(nil, response, nil)
          }
          
        }
        
        it("should not return an error") {
          api = PMAPI(authService: mockAuthService, httpService: GoodResponseMockHTTPService(), requestFactory: mockRequestFactory, baseURL: baseURL)
          
          waitUntil { done in
            api.register(user) { error in
              expect(error).to(beNil())

              done()
            }
          }
        }
      }

    }
    
  }
  
}
