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
    let clientSecret = "clientSecret"
    let email = "test@testmail.com"
    let password = "1234"
    let expectedTokenURL = URL(string: "http://www.poke.me/oauth/token")!
    let passwordGrantTypeData = Data(bytes: [UInt8]("grant_type=password&username=test@testmail.com&password=1234".utf8))

    describe("authenticate") {
      it("should fire a POST request to the baseURL/oauth/token endpoint with password grant type") {
        class MockHttpService: PMHttpService {

          var lastRequest: URLRequest?

          func request(_ request: URLRequest, _ response: (Error?, HTTPURLResponse?, Data?) -> Void) {
            lastRequest = request
          }

        }

        let mockHttpService = MockHttpService()
        sut = PMOAuth2AuthenticationManager(
          baseURL: baseURL,
          clientId: clientId,
          clientSecret: clientSecret,
          httpService: mockHttpService
        )

        sut.authenticate(email: email, password: password)

        let lastRequest = mockHttpService.lastRequest

        expect(lastRequest).toNot(beNil())
        expect(lastRequest?.url).to(equal(expectedTokenURL))
        expect(lastRequest?.httpBody).to(equal(passwordGrantTypeData))
        expect(lastRequest?.httpMethod).to(equal("POST"))
      }

      context("on valid response") {
        it("should call the success delegate method") {
          class MockAuthenticationManagerDelegate: PMAuthenticationManagerDelegate {

            var successCalled: Bool? = nil

            func authenticationManagerDidAuthenticate(_ authenticationManager: PMAuthenticationManager) {
              successCalled = true
            }

            func authenticationManagerFailedToAuthenticate(_ authenticationManager: PMAuthenticationManager) {
              successCalled = false
            }

          }

          class StubHttpService: PMHttpService {

            func request(_ request: URLRequest, _ response: (Error?, HTTPURLResponse?, Data?) -> Void) {
              var httpURLResponse = HTTPURLResponse(url: URL(string: "http://www.poke.me/oauth/token")!,
                                                    statusCode: 200, httpVersion: nil, headerFields: nil)
              var responseJSON = """
                {
                  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",
                  "token_type":"bearer",
                  "expires_in":3600,
                  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",
                  "scope":"create",
                  "state":"12345678
                }
              """
              var responseData = Data(bytes: [UInt8](responseJSON.utf8))

              response(nil, httpURLResponse, responseData)
            }

          }
        }
      }
    }

  }

}
