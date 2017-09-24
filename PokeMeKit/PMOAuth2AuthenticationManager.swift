//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public class PMOAuth2AuthenticationManager: PMAuthenticationManager {

  private let baseURL: URL
  private let clientId: String
  private let clientSecret: String
  private let httpService: PMHttpService
  public weak var delegate: PMAuthenticationManagerDelegate?

  private final let tokenEndpoint = "oauth/token"

  init(baseURL: URL, clientId: String, clientSecret: String, httpService: PMHttpService) {
    self.baseURL = baseURL
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.httpService = httpService
  }

  public private(set) var authenticated: Bool = false

  public func authenticate(email: String, password: String) {

    let tokenEndpointURL = baseURL.appendingPathComponent(tokenEndpoint)

    var request = URLRequest(url: tokenEndpointURL)
    request.httpBody = passwordCredentialRequestBody(with: email, and: password)
    request.httpMethod = "POST"

    httpService.request(request, { error, response, data in

    });

  }

  public func authenticate(request: URLRequest) -> URLRequest {
    fatalError("authenticate(request:) has not been implemented")
  }

  private func passwordCredentialRequestBody(with email: String, and password: String) -> Data? {
    var urlComponents = URLComponents()
    urlComponents.queryItems = [
      URLQueryItem(name: "grant_type", value: "password"),
      URLQueryItem(name: "username", value: email),
      URLQueryItem(name: "password", value: password)
    ]

    guard let httpBodyString = urlComponents.string else {
      return nil
    }

    return Data(bytes: [UInt8](httpBodyString[httpBodyString.index(after: httpBodyString.startIndex)...].utf8))
  }

}