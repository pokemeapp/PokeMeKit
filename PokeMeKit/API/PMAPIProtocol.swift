//
//  PMAPIProtocol.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 29..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

public protocol PMAPIEntity: Codable {
  
}

public enum PMAPIError: Error {
  
  case validationUnsuccessful
  case badResponseCode(Int)
  case tokenNotFound
  
}

public protocol PMAPIProtocol {
  
  typealias PMAPIErrorCallback = (Error?) -> Void
  
  typealias PMAPIEntityCallback<Entity: PMAPIEntity> = (Error?, Entity?) -> Void
    
  var isLoggedIn: Bool {get}
  
  func register(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback)
  
  func login(with email: String, and password: String , _ callback: @escaping PMAPIErrorCallback)
  
  func get<E: PMAPIEntity>(_ callback: @escaping PMAPIEntityCallback<E>)
  
  func post<E: PMAPIEntity>(_ callback: @escaping PMAPIEntityCallback<E>)
  
  func patch<E: PMAPIEntity>(_ callback: @escaping PMAPIEntityCallback<E>)
  
}
