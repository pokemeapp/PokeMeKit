//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public protocol PMAuthenticationManager {

  func authenticate(email: String, password: String, _ callback: @escaping (PMAPIError?) -> Void)

  func authenticate(request: URLRequest) throws -> URLRequest

}
