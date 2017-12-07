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

  private final let tokenEndpoint = "oauth/token"

  private let accessTokenKey = "PokeMe.AccessToken"
  private var accessToken: String? = nil {
    didSet {
      UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
    }
  }
  
  private let refreshTokenKey = "PokeMe.RefreshToken"
  private var refreshToken: String? = nil {
    didSet {
      UserDefaults.standard.set(accessToken, forKey: refreshTokenKey)
    }
  }
    
  public var isLoggedIn: Bool {
    return refreshToken != nil
  }

  public init(baseURL: URL, clientId: String, clientSecret: String, httpService: PMHTTPService) {
    self.baseURL = baseURL
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.httpService = httpService
    
    if let accessToken = UserDefaults.standard.string(forKey: accessTokenKey) {
      self.accessToken = accessToken
    }
    
    if let refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey) {
      self.refreshToken = refreshToken
    }
  }

  public func authenticate(email: String, password: String, _ callback: @escaping (Error?) -> Void) {

    let tokenEndpointURL = baseURL.appendingPathComponent(tokenEndpoint)

    var request = URLRequest(url: tokenEndpointURL)
    request.httpBody = passwordCredentialRequestBody(with: email, and: password)
    request.httpMethod = "POST"

    let credentials = "\(clientId):\(clientSecret)"
    let credentialsData = Data(bytes: [UInt8](credentials.utf8))
    let base64credentials = credentialsData.base64EncodedString()

    request.addValue("Basic \(base64credentials)", forHTTPHeaderField: "Authorization")

    httpService.request(request, { error, response, data in
      guard error == nil else {
        return callback(error)
      }

      guard let responseData = data else {
        return
      }

      if let successfulResponse = try? self.decoder.decode(SuccessfulResponse.self, from: responseData) {
        self.accessToken = successfulResponse.access_token
        self.refreshToken = successfulResponse.refresh_token
        callback(nil)
      } else if let _ = try? self.decoder.decode(UnsuccessfulResponse.self, from: responseData) {
        callback(PMAPIError.validationUnsuccessful)
      }

    });

  }

  public func authenticate(request: URLRequest) throws -> URLRequest {
    if accessToken == nil {
      throw PMAPIError.tokenNotFound
    }

    var authorizedRequest = request
    authorizedRequest.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
    return authorizedRequest
  }
  
  public func logout() {
    UserDefaults.standard.set(nil, forKey: accessTokenKey)
    UserDefaults.standard.set(nil, forKey: refreshTokenKey)
    accessToken = nil
    refreshToken = nil
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
