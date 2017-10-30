//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Foundation

public class PMOAuth2AuthenticationManager: PMAuthenticationManager {

  private struct SuccessfulResponse: Codable {
    var access_token: String
    var token_type: String
    var expires_in: Int?
    var refresh_token: String?
    var scope: String?
  }

  private struct UnsuccessfulResponse: Codable {
    var error: String
    var error_description: String?
    var error_uri: String?
  }

  private let baseURL: URL
  private let clientId: String
  private let clientSecret: String
  private let httpService: PMHTTPService
  private let decoder = JSONDecoder()

  public weak var delegate: PMAuthenticationManagerDelegate?

  private final let tokenEndpoint = "oauth/token"

  public init(baseURL: URL, clientId: String, clientSecret: String, httpService: PMHTTPService) {
    self.baseURL = baseURL
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.httpService = httpService
  }

  public func authenticate(email: String, password: String) {

    let tokenEndpointURL = baseURL.appendingPathComponent(tokenEndpoint)

    var request = URLRequest(url: tokenEndpointURL)
    request.httpBody = passwordCredentialRequestBody(with: email, and: password)
    request.httpMethod = "POST"

    let credentials = "\(clientId):\(clientSecret)"
    let credentialsData = Data(bytes: [UInt8](credentials.utf8))
    let base64credentials = credentialsData.base64EncodedString()

    request.addValue("Basic \(base64credentials)", forHTTPHeaderField: "Authorization")

    httpService.request(request, { error, response, data in

      guard let responseData = data else {
        self.delegate?.authenticationManagerFailedToAuthenticate(self)
        return
      }

      if let successfulResponse = try? decoder.decode(SuccessfulResponse.self, from: responseData) {
        self.delegate?.authenticationManagerDidAuthenticate(self)
      } else if let unsuccessfulResponse = try? decoder.decode(UnsuccessfulResponse.self, from: responseData) {
        self.delegate?.authenticationManagerFailedToAuthenticate(self)
      }

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
