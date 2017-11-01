//
// Created by Simkó Viktor on 2017. 09. 19..
// Copyright (c) 2017 PokeMe. All rights reserved.
//

import Quick
import Nimble
@testable import PokeMeKit

class PMOAuth2AuthenticationManagerSpec: QuickSpec {

  override func spec() {

    var sut: PMOAuth2AuthenticationManager!
    let baseURL = URL(string: "http://www.poke.me")!
    let clientId = "clientId"
    let clientSecret = "clientSecret£"
    let email = "test@testmail.com"
    let password = "1234"
    let expectedTokenURL = URL(string: "http://www.poke.me/oauth/token")!
    let passwordGrantTypeData = Data(bytes: [UInt8]("grant_type=password&username=test@testmail.com&password=1234".utf8))

    describe("authenticate") {
      class MockAuthenticationManagerDelegate: PMAuthenticationManagerDelegate {

        var successCalled: Bool? = nil
        var authenticationManagerPassed: PMAuthenticationManager?

        func authenticationManagerDidAuthenticate(_ authenticationManager: PMAuthenticationManager) {
          successCalled = true
          authenticationManagerPassed = authenticationManager
        }

        func authenticationManagerFailedToAuthenticate(_ authenticationManager: PMAuthenticationManager) {
          successCalled = false
          authenticationManagerPassed = authenticationManager
        }

      }

      context("given a username and a password") {
        class MockHttpService: PMHTTPService {

          var lastRequest: URLRequest?

          func request(_ request: URLRequest, _ response: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
            lastRequest = request
          }

        }

        var mockHttpService: MockHttpService!
        var lastRequest: URLRequest?

        beforeEach {
          mockHttpService = MockHttpService()

          sut = PMOAuth2AuthenticationManager(
            baseURL: baseURL,
            clientId: clientId,
            clientSecret: clientSecret,
            httpService: mockHttpService
          )

          sut.authenticate(email: email, password: password)

          lastRequest = mockHttpService.lastRequest
        }

        it("should send a POST request to the baseURL/oauth/token endpoint with password grant type") {
          expect(lastRequest).toNot(beNil())
          expect(lastRequest?.httpMethod).to(equal("POST"))
        }

        it("should send the request to the /oauth/token endpoint") {
          expect(lastRequest?.url).to(equal(expectedTokenURL))
        }

        it("should send the request with password grant type data") {
          expect(lastRequest?.httpBody).to(equal(passwordGrantTypeData))
        }

        it("should send the request with http basic authentication with the client credentials") {
          var authenticationHeader = lastRequest?.allHTTPHeaderFields?["Authorization"]

          expect(authenticationHeader).to(equal("Basic Y2xpZW50SWQ6Y2xpZW50U2VjcmV0wqM="))
        }
      }

      context("on valid response") {
        it("should call the success delegate method") {

          class StubHttpService: PMHTTPService {

            func request(_ request: URLRequest, _ response: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
              let httpURLResponse = HTTPURLResponse(url: URL(string: "http://www.poke.me/oauth/token")!,
                                                    statusCode: 200, httpVersion: nil, headerFields: nil)
              let responseJSON = """
                {
                  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",
                  "token_type":"bearer",
                  "expires_in":3600,
                  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",
                  "scope":"create"
                }
              """
              let responseData = Data(bytes: [UInt8](responseJSON.utf8))

              response(nil, httpURLResponse, responseData)
            }

          }

          let mockAuthenticationManagerDelegate = MockAuthenticationManagerDelegate()

          sut = PMOAuth2AuthenticationManager(
            baseURL: baseURL,
            clientId: clientId,
            clientSecret: clientSecret,
            httpService: StubHttpService()
          )

          sut.delegate = mockAuthenticationManagerDelegate

          sut.authenticate(email: email, password: password)

          expect(mockAuthenticationManagerDelegate.successCalled).to(beTrue())
          expect(mockAuthenticationManagerDelegate.authenticationManagerPassed).to(be(sut))
        }
      }

      context("on invalid response") {
        it("should call the failed delegate method") {
          class StubHttpService: PMHTTPService {

            func request(_ request: URLRequest, _ response: @escaping (Error?, HTTPURLResponse?, Data?) -> Void) {
              let httpURLResponse = HTTPURLResponse(url: URL(string: "http://www.poke.me/oauth/token")!,
                                                    statusCode: 200, httpVersion: nil, headerFields: nil)
              let responseJSON = """
                {
                  "error": "invalid_request",
                  "error_description": "Request was missing the 'redirect_uri' parameter.",
                  "error_uri": "See the full API docs at https://authorization-server.com/docs/access_token"
                }
              """
              let responseData = Data(bytes: [UInt8](responseJSON.utf8))

              response(nil, httpURLResponse, responseData)
            }

          }

          let mockAuthenticationManagerDelegate = MockAuthenticationManagerDelegate()

          sut = PMOAuth2AuthenticationManager(
            baseURL: baseURL,
            clientId: clientId,
            clientSecret: clientSecret,
            httpService: StubHttpService()
          )

          sut.delegate = mockAuthenticationManagerDelegate

          sut.authenticate(email: email, password: password)

          expect(mockAuthenticationManagerDelegate.successCalled).to(beFalse())
          expect(mockAuthenticationManagerDelegate.authenticationManagerPassed).to(be(sut))
        }
      }
    }

  }

}
