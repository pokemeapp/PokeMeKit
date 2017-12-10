//
//  PMAlamofireHTTPService.swift
//  PokeMeKit
//
//  Created by Simkó Viktor on 2017. 11. 01..
//  Copyright © 2017. PokeMe. All rights reserved.
//

import Foundation
import OHHTTPStubs
import Alamofire

public class PMAlamofireHTTPService: PMHTTPService {
  
  public init() {
    //initStubs()
  }
  
  private func initStubs() {
    stub(condition: isHost("localhost") && isPath("/api/user/friends")) { _ in
      let stubPath = OHPathForFile("friends.json", type(of: self))
      return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
    }
  }
  
  public func request(_ urlRequest: URLRequest, _ callback: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {

    Alamofire.request(urlRequest).responseData { response in

      callback(response.error, response.response, response.data)
      
    }
  }

}
