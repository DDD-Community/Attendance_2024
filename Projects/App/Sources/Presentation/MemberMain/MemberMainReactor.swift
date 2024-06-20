//
//  MemberMainReactor.swift
//  DDDAttendance
//
//  Created by 고병학 on 6/8/24.
//

import ReactorKit

import Foundation

final class MemberMainReactor: Reactor {
    struct State {
        var todayEvent: DDDEvent?
        var userProfile: Member?
        var userAttendanceHistory: [Attendance] = []
        var checkInSuccess: Bool?
        var isUserLoggedOut: Bool?
    }
    
    enum Action {
        case fetchTodayEvent
        case fetchProfile
        case fetchUserAttendanceHistory
        case didTapCheckIn
        case didTapLogout
    }
    
    enum Mutation {
        case setTodayEvent(DDDEvent)
        case setProfile(Member)
        case setUserAttendanceHistory([Attendance])
        case setCheckInSuccess(Bool)
        case setLogoutSuccess(Bool)
    }
    
    let initialState: State
    private let userRepository: UserRepositoryProtocol
    private let eventRepository: EventRepositoryProtocol
    
    init() {
        self.initialState = .init()
        self.userRepository = UserRepository()
        self.eventRepository = EventRepository()
        self.action.onNext(.fetchProfile)
        self.action.onNext(.fetchTodayEvent)
        self.action.onNext(.fetchUserAttendanceHistory)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchTodayEvent:
            return self.fetchTodayEvent()
        case .fetchProfile:
            return self.fetchProfile()
        case .fetchUserAttendanceHistory:
            return self.fetchUserAttendanceHistory()
        case .didTapCheckIn:
            return saveCheckIn()
        case .didTapLogout:
            return logout()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTodayEvent(let event):
            newState.todayEvent = event
        case .setProfile(let profile):
            newState.userProfile = profile
        case .setUserAttendanceHistory(let history):
            newState.userAttendanceHistory = history
        case .setCheckInSuccess(let success):
            newState.checkInSuccess = success
        case .setLogoutSuccess(let success):
            newState.isUserLoggedOut = success
        }
        return newState
    }
}

extension MemberMainReactor {
    private func saveCheckIn() -> Observable<Mutation> {
        let attendance: Attendance = self.buildAttendance()
        return self.userRepository.checkMemberAttendance(attendance)
            .map { Mutation.setCheckInSuccess($0) }
            .asObservable()
    }
    
    private func fetchProfile() -> Observable<Mutation> {
        return self.userRepository.fetchMember()
            .map { Mutation.setProfile($0) }
            .catchAndReturn(.setLogoutSuccess(true))
            .asObservable()
    }
    
    private func fetchTodayEvent() -> Observable<Mutation> {
        return self.eventRepository.fetchTodayEvent()
            .map { Mutation.setTodayEvent($0) }
            .asObservable()
    }
    
    private func fetchUserAttendanceHistory() -> Observable<Mutation> {
        return self.userRepository.fetchAttendanceList()
            .map { Mutation.setUserAttendanceHistory($0) }
            .asObservable()
    }
    
    private func logout() -> Observable<Mutation> {
        return self.userRepository.logout()
            .map { Mutation.setLogoutSuccess($0) }
            .asObservable()
    }
}

extension MemberMainReactor {
    private func buildAttendance() -> Attendance {
        let date: Date = .init()
        let memberId: String = self.currentState.userProfile?.uid ?? ""
        let eventId: String = self.currentState.todayEvent?.id ?? ""
        let attendanceType: AttendanceType = buildAttendanceType()
        
        return .init(
            id: UUID().uuidString,
            memberId: memberId,
            eventId: eventId,
            createdAt: date,
            updatedAt: date,
            attendanceType: attendanceType,
            generation: 11
        )
    }
    
    private func buildAttendanceType() -> AttendanceType {
        let date: Date = .init()
        let lateLimitSecond: Int = 60 * 5
        let eventStartTime: Date = self.currentState.todayEvent?.startTime ?? .init()
        let eventEndTime: Date = self.currentState.todayEvent?.endTime ?? .init()
        
        if date > eventStartTime.addingTimeInterval(TimeInterval(lateLimitSecond)) {
            return .late
        } else if date > eventEndTime {
            return .absent
        }
        return .present
    }
}
