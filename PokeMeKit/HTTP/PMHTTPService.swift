//
// Created by Simkó Viktor on 2017. 09. 21..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public protocol PMHTTPService {
  
  typealias PMAPIResponseCallback = (Error?, HTTPURLResponse?, Data?) -> Void

  func request(_ urlRequest: URLRequest, _ callback: @escaping PMAPIResponseCallback)

}
