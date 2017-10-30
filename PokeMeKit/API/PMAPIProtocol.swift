//
//  PMAPIProtocol.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 10. 29..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation

protocol PMAPIEntity: Codable {
  
}

public enum PMAPIError: Error {
  
  case validationUnsuccessful
  case badResponseCode(Int)

}

public protocol PMAPIProtocol {
  
  typealias PMAPIErrorCallback = (Error?) -> Void
  
  typealias PMAPIEntityCallback<Entity: PMAPIEntity> = (Error?, Entity?) -> Void
  
  func register(_ user: PMUser, _ callback: PMAPIErrorCallback)
  
  func login(_ user: PMUser, _ callback: PMAPIErrorCallback)
  
  func getUser(_ callback: PMAPIEntityCallback<PMUser>)
  
}
