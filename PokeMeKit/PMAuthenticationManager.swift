//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public protocol PMAuthenticationManagerDelegate: class {

  func authenticationManagerDidAuthenticate(_ authenticationManager: PMAuthenticationManager)

  func authenticationManagerFailedToAuthenticate(_ authenticationManager: PMAuthenticationManager)

}

public protocol PMAuthenticationManager {

  var authenticated: Bool { get }

  func authenticate(email: String, password: String)

  func authenticate(request: URLRequest) -> URLRequest

}