//
//  SNSLoginViewController.swift
//  DDDAttendance
//
//  Created by 고병학 on 6/6/24.
//

import ReactorKit

import UIKit

final class SNSLoginViewController: UIViewController {
    typealias Reactor = SNSLoginReactor
    
    // MARK: - UI properties
    private var mainView: SNSLoginView { view as! SNSLoginView }
    
    // MARK: - Properties
    var disposeBag: DisposeBag = .init()
    
    // MARK: - Lifecycles
    override func loadView() {
        view = SNSLoginView()
        reactor = SNSLoginReactor()
    }
    
    // MARK: - Public helpers
    
    // MARK: - Private helpers
    private func routeToSignup() {
        if mainView.coreMemberCheckSwitch.isOn {
            self.routeToCoreMemberSignup()
        } else {
            self.routeToMemberSignup()
        }
    }
    
    private func routeToMemberSignup() {
        self.alertMessage(#function)
    }
    
    private func routeToMemberMain() {
        self.alertMessage(#function)
    }
    
    private func routeToCoreMemberSignup() {
        self.alertMessage(#function)
    }
    
    private func routeToCoreMemberMain() {
        self.alertMessage(#function)
    }
    
    private func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension SNSLoginViewController: View {
    func bind(reactor: Reactor) {
        mainView.appleLoginButton.rx.throttleTap
            .map { Reactor.Action.didTapAppleLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.googleLoginButton.rx.throttleTap
            .map { Reactor.Action.didTapGoogleLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.oAuthTokenResponse }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .map { Reactor.Action.checkIsSignedMember($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userUID }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .map { Reactor.Action.checkMemberType(uid: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.memberType }
            .distinctUntilChanged()
            .compactMap { $0 }
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] memberType in
                switch memberType {
                case .master, .coreMember: self?.routeToCoreMemberMain()
                case .member: self?.routeToMemberMain()
                case .notYet:  self?.routeToSignup()
                case .run: self?.alertMessage("탈주자 계정입니다.")
                }
            }.disposed(by: disposeBag)
    }
}
