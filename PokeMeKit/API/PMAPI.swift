//
//  PMAPI.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 29..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

class PMAPI: PMAPIProtocol {
  
  enum Route: String {
    case register = "api/register"
  }

  let authService: PMAuthenticationManager
  let httpService: PMHTTPService
  let requestFactory: PMAPIRequestFactoryProtocol
  let baseURL: URL
  
  init(authService: PMAuthenticationManager, httpService: PMHTTPService, requestFactory: PMAPIRequestFactoryProtocol, baseURL: URL) {
    self.requestFactory = requestFactory
    self.authService = authService
    self.httpService = httpService
    self.baseURL = baseURL
  }
  
  func register(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback) {
    let request = requestFactory.make(baseURL: baseURL, route: .register, method: .POST, content: user)

    httpService.request(request) { error, response, data in
      
      if let _ = error {
        return callback(error)
      }
      
      guard let res = response else {
        // TODO
        fatalError("No response")
      }
      
      if res.statusCode == 201 {
        return callback(nil)
      }
      
      if res.statusCode == 400 {
        return callback(PMAPIError.validationUnsuccessful)
      }
      
      callback(PMAPIError.badResponseCode(res.statusCode))
      
    }
  }
  
  func login(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback) {
  }
  
  func getUser(_ callback: @escaping PMAPIEntityCallback<PMUser>) {
  }

}
