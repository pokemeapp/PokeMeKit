//
//  PMAPI.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 29..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public class PMAPI: PMAPIProtocol {
  
  public enum Route: String {
    case register = "api/register"
  }

  private let authService: PMAuthenticationManager
  private let httpService: PMHTTPService
  private let requestFactory: PMAPIRequestFactoryProtocol
  private let baseURL: URL
  
  public init(authService: PMAuthenticationManager, httpService: PMHTTPService, requestFactory: PMAPIRequestFactoryProtocol, baseURL: URL) {
    self.requestFactory = requestFactory
    self.authService = authService
    self.httpService = httpService
    self.baseURL = baseURL
  }
  
  public func register(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback) {
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
  
  public func login(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback) {
  }
  
  public func getUser(_ callback: @escaping PMAPIEntityCallback<PMUser>) {
  }

}
