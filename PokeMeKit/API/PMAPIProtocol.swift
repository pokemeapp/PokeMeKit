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

extension String: PMAPIEntity {

}

public enum PMAPIError: Error {
  
  case validationUnsuccessful
  case badResponseCode(Int)
  case tokenNotFound
  case noData
  case entityTypeMismatch
  
}

public protocol PMAPIProtocol {
  
  typealias PMAPIErrorCallback = (Error?) -> Void
  
  typealias PMAPIEntityCallback<Entity: PMAPIEntity> = (Error?, Entity?) -> Void
  
  typealias PMAPIEntitiesCallback<Entity: PMAPIEntity> = (Error?, [Entity]?) -> Void
    
  var isLoggedIn: Bool {get}
  
  func register(_ user: PMUser, _ callback: @escaping PMAPIErrorCallback)
  
  func login(with email: String, and password: String , _ callback: @escaping PMAPIErrorCallback)
  
  func get<E: PMAPIEntity>(_ route: String, _ callback: @escaping PMAPIEntityCallback<E>)
  
  func get<E: PMAPIEntity>(_ route: String, query: [String: String]?, _ callback: @escaping PMAPIEntitiesCallback<E>)
  
  func post<E: PMAPIEntity>(_ route: String, entity: E, _ callback: @escaping PMAPIEntityCallback<E>)
  
  func put<E: PMAPIEntity>(_ route: String, entity: E, _ callback: @escaping PMAPIEntityCallback<E>)

  func delete<E: PMAPIEntity>(_ route: String, entity: E, _ callback: @escaping PMAPIEntityCallback<E>)

}
