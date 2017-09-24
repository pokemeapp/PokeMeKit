//
// Created by Simkó Viktor on 2017. 09. 21..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public protocol PMHttpService {

  func request(_ url: URLRequest, _ response: (Error?, HTTPURLResponse?, Data?) -> Void)

}
