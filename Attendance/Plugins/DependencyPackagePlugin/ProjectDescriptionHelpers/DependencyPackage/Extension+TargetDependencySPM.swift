//
//  Extension+TargetDependencySPM.swift
//  DependencyPackagePlugin
//
//  Created by 서원지 on 4/19/24.
//

import ProjectDescription

public extension TargetDependency.SPM {
  static let asyncMoya = TargetDependency.external(name: "AsyncMoya", condition: .none)
  static let logMarco = TargetDependency.external(name: "LogMarco", condition: .none)
  
  static let composableArchitecture = TargetDependency.external(name: "ComposableArchitecture", condition: .none)
  static let tcaCoordinator = TargetDependency.external(name: "TCACoordinators", condition: .none)
  static let concurrencyExtras = TargetDependency.external(name: "ConcurrencyExtras", condition: .none)
  static let sdwebImage = TargetDependency.external(name: "SDWebImageSwiftUI", condition: .none)
  static let swiftUIX = TargetDependency.external(name: "SwiftUIX", condition: .none)
  static let fsCalendar = TargetDependency.external(name: "FSCalendar", condition: .none)
  
  static let gifu = TargetDependency.external(name: "Gifu", condition: .none)
  static let then = TargetDependency.external(name: "Then", condition: .none)
  static let flexLayout = TargetDependency.external(name: "FlexLayout", condition: .none)
  static let pinLayout = TargetDependency.external(name: "PinLayout", condition: .none)
  static let reactorKit = TargetDependency.external(name: "ReactorKit", condition: .none)
  static let rxCocoa = TargetDependency.external(name: "RxCocoa", condition: .none)
  static let snapKit = TargetDependency.external(name: "SnapKit", condition: .none)
  static let qrCodeSwift = TargetDependency.external(name: "QRCodeSwift", condition: .none)
  
  static let keychainAccess = TargetDependency.external(name: "KeychainAccess", condition: .none)
  static let popupView = TargetDependency.external(name: "PopupView", condition: .none)
  static let collections = TargetDependency.external(name: "Collections", condition: .none)
  
  
  static let googleSignIn = TargetDependency.external(name: "GoogleSignIn", condition: .none)
  static let firebaseAuth = TargetDependency.external(name: "FirebaseAuth", condition: .none)
  static let firebaseFirestore = TargetDependency.external(name: "FirebaseFirestore", condition: .none)
  static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics", condition: .none)
  static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics", condition: .none)
  static let firebaseRemoteConfig = TargetDependency.external(name: "FirebaseRemoteConfig", condition: .none)
  static let firebaseDatabase = TargetDependency.external(name: "FirebaseDatabase", condition: .none)
}


