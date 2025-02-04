//
//  OAuthService.swift
//  DDDAttendance
//
//  Created by 고병학 on 6/6/24.
//

import Foundation

import RxSwift

protocol OAuthServiceProtocol {
  func authorize() -> Single<OAuthTokenResponse>
}
