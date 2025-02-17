//
//  OAuthRepositoryProtocol.swift
//  UseCase
//
//  Created by Wonji Suh  on 10/30/24.
//
import Foundation
import AuthenticationServices
import Model

//TODO: -  애플로그인 및  구글 로그인 로직 구현 후 코디네이터 연결
public protocol OAuthRepositoryProtocol {
  func handleAppleLogin(_ requestResult: Result<ASAuthorization, Error>, nonce: String) async throws -> ASAuthorization
  func appleLoginWithFireBase(
    withIDToken: String ,
    rawNonce: String,
    fullName: ASAuthorizationAppleIDCredential
  ) async throws -> OAuthResponseDTOModel?
  func googleLogin() async throws -> OAuthResponseDTOModel?
}
