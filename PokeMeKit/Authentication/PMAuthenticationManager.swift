//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public protocol PMAuthenticationManager {
  
  var isLoggedIn: Bool {get}

  func authenticate(email: String, password: String, _ callback: @escaping (Error?) -> Void)

  func authenticate(request: URLRequest) throws -> URLRequest

}
