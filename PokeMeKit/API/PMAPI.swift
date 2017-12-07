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
  private let decoder = JSONDecoder()
    
  public var isLoggedIn: Bool {
    return authService.isLoggedIn
  }
  
  public init(authService: PMAuthenticationManager, httpService: PMHTTPService, requestFactory: PMAPIRequestFactoryProtocol, baseURL: URL) {
    self.requestFactory = requestFactory
    self.authService = authService
    self.httpService = httpService
    self.baseURL = baseURL
  }
  
  public func register(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback) {
    let request = requestFactory.make(baseURL: baseURL, route: Route.register.rawValue, method: .POST, content: user)

    httpService.request(request) { error, response, data in
      
      guard error == nil else {
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
  
  public func login(with email: String, and password: String, _ callback: @escaping PMAPIErrorCallback) {
    authService.authenticate(email: email, password: password, callback)
  }
  
  public func logout() {
    authService.logout()
  }
  
  public func get<E>(_ route: String, _ callback: @escaping (Error?, E?) -> Void) where E : PMAPIEntity {
    var request = requestFactory.make(baseURL: baseURL, route: route, method: PMAPIMethod.GET, content: Optional<E>.none)
    
    request = try! authService.authenticate(request: request)
    
    httpService.request(request) { error, response, data in
      guard error == nil else {
        return callback(error, nil)
      }
      
      guard let res = response else {
        // TODO
        fatalError("No response")
      }
      
      guard res.statusCode == 200 else {
        
        if res.statusCode == 400 {
          return callback(PMAPIError.validationUnsuccessful, nil)
        }
        
        return callback(PMAPIError.badResponseCode(res.statusCode), nil)
      }
  
      guard let data = data else {
        return callback(PMAPIError.noData, nil)
      }
      
      guard let entity = try? self.decoder.decode(E.self, from: data) else {
        return callback(PMAPIError.entityTypeMismatch, nil)
      }
      
      callback(nil, entity)
    }
  }
  
  public func get<E>(_ route: String, _ callback: @escaping (Error?, [E]?) -> Void) where E : PMAPIEntity {
    var request = requestFactory.make(baseURL: baseURL, route: route, method: PMAPIMethod.GET, content: Optional<E>.none)

    request = try! authService.authenticate(request: request)
    
    httpService.request(request) { error, response, data in
      guard error == nil else {
        return callback(error, nil)
      }

      guard let res = response else {
        // TODO
        fatalError("No response")
      }

      guard res.statusCode == 200 else {

        if res.statusCode == 400 {
          return callback(PMAPIError.validationUnsuccessful, nil)
        }

        return callback(PMAPIError.badResponseCode(res.statusCode), nil)
      }

      guard let data = data else {
        return callback(PMAPIError.noData, nil)
      }

      guard let entity = try? self.decoder.decode([E].self, from: data) else {
        return callback(PMAPIError.entityTypeMismatch, nil)
      }

      callback(nil, entity)
    }
  }
  
  public func post<E>(_ route: String, entity: E, _ callback: @escaping (Error?, E?) -> Void) where E : PMAPIEntity {
    var request = requestFactory.make(baseURL: baseURL, route: route, method: PMAPIMethod.POST, content: entity)
    
    request = try! authService.authenticate(request: request)
    
    httpService.request(request) { error, response, data in
      guard error == nil else {
        return callback(error, nil)
      }
      
      guard let res = response else {
        // TODO
        fatalError("No response")
      }
      
      guard res.statusCode == 200 else {
        
        if res.statusCode == 400 {
          return callback(PMAPIError.validationUnsuccessful, nil)
        }
        
        if res.statusCode == 204 {
          return callback(nil, nil)
        }
        
        return callback(PMAPIError.badResponseCode(res.statusCode), nil)
      }
      
      guard let data = data else {
        return callback(PMAPIError.noData, nil)
      }
      
      guard let entity = try? self.decoder.decode(E.self, from: data) else {
        return callback(PMAPIError.entityTypeMismatch, nil)
      }
      
      callback(nil, entity)
    }
  }
  
  public func put<E>(_ route: String, entity: E, _ callback: @escaping (Error?, E?) -> Void) where E : PMAPIEntity {
    var request = requestFactory.make(baseURL: baseURL, route: route, method: PMAPIMethod.PUT, content: entity)
    
    request = try! authService.authenticate(request: request)
    
    httpService.request(request) { error, response, data in
      guard error == nil else {
        return callback(error, nil)
      }
      
      guard let res = response else {
        // TODO
        fatalError("No response")
      }
      
      guard res.statusCode == 200 else {
        
        if res.statusCode == 400 {
          return callback(PMAPIError.validationUnsuccessful, nil)
        }
        
        if res.statusCode == 204 {
          return callback(nil, nil)
        }
        
        return callback(PMAPIError.badResponseCode(res.statusCode), nil)
      }
      
      guard let data = data else {
        return callback(PMAPIError.noData, nil)
      }
      
      guard let entity = try? self.decoder.decode(E.self, from: data) else {
        return callback(PMAPIError.entityTypeMismatch, nil)
      }
      
      callback(nil, entity)
    }
  }

}
