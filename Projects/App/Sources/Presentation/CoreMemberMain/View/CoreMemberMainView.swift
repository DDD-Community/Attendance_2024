//
//  CoreMemberMainView.swift
//  DDDAttendance
//
//  Created by 서원지 on 6/6/24.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct CoreMemberMainView: View {
    @Bindable var store: StoreOf<CoreMember>
    
    
    init(store: StoreOf<CoreMember>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                titleView()
                
                attendanceStatus(selectPart: store.selectPart ?? .all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    selctAttendance(selectPart: store.selectPart ?? .all)
                    
                    Spacer()
                }
                .bounce(false)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
        .task {
            store.send(.fetchMember)
        }
        .onAppear {
            store.send(.appearSelectPart(selectPart: .all))
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -UIScreen.screenWidth * 0.02 {
                        store.send(.swipeNext)
                    } else if value.translation.width > UIScreen.screenWidth * 0.02 {
                        store.send(.swipePrevious)
                    }
                }
        )
        
        
    }
    
    private func registerDependencies() {
        Task {
            await AppDIContainer.shared.registerDependencies()
        }
    }
}

extension CoreMemberMainView {
    
    @ViewBuilder
    fileprivate func titleView() -> some View {
        VStack {
            Spacer()
                .frame(height: UIScreen.screenHeight*0.02)
            
            HStack {
                Text(store.headerTitle)
                    .foregroundStyle(Color.basicWhite)
                    .font(.system(size: 30))
                    .fontDesign(.rounded)
                    .bold(true)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    fileprivate func attendanceStatus(selectPart: SelectPart) -> some View {
        LazyVStack {
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.02)
            
            ScrollViewReader { proxy in
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(SelectPart.allCases, id: \.self) { item in
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(store.selectPart == item ? Color.gray : Color.white, lineWidth: 1)
                                    .background(store.selectPart == item ? Color.famous : Color.clear)
                                    .cornerRadius(12)
                                    .frame(width: UIScreen.main.bounds.width * 0.23, height: 30)
                                    .overlay(
                                        Text(item.desc)
                                            .foregroundColor(.white)
                                            .pretendardFont(family: .Bold, size: 16)
                                    )
                                    .onTapGesture {
                                        store.send(.selectPartButton(selectPart: item))
                                        store.send(.upDateFetchMember(selectPart: item))
                                    }
                                    .id(item)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .onChange(of: store.selectPart, { oldValue, newValue in
                    proxy.scrollTo(newValue, anchor: .center)
                })
            }
            
            Spacer()
                .frame(height: 20)
            
        }
    }
    
    @ViewBuilder
    fileprivate func selctAttendance(selectPart: SelectPart) -> some View {
        
        LazyVStack {
            switch store.selectPart {
            case .all:
                attendanceMemberList(roleType: selectPart)
                
            default:
                if store.attendaceModel.isEmpty {
                   
                    VStack {
                        Spacer()
                            .frame(height: UIScreen.screenHeight * 0.2)
                        
                        AnimatedImage(name: "DDDLoding.gif", isAnimating: .constant(true))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Spacer()
                    }
                    
                } else {
                    attendanceMemberList(roleType: selectPart)
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func attendanceMemberList(roleType: SelectPart) -> some View {
        Spacer()
            .frame(height: 20)
        
        VStack {
            switch roleType {
            case .all:
                ScrollView(.vertical ,showsIndicators: false) {
                    ForEach(store.attendaceModel, id: \.self) { item in
                        attendanceList(name: "\(item.name) \(item.generation) 기", roleType: item.roleType.desc)
                        
                        Spacer()
                    }
                }
            default:
                ForEach(store.attendaceModel.filter { $0.roleType == roleType}, id: \.self) { item in
                    attendanceList(name: "\(item.name) \(item.generation) 기", roleType: item.roleType.desc)
                    
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    fileprivate func attendanceList(name: String,  roleType: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.basicWhite, style: .init(lineWidth: 1))
                .frame(height: 60)
                .overlay {
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(height: 12)
                            Text(name)
                                .foregroundColor(.basicWhite)
                                .pretendardFont(family: .SemiBold, size: 20)
                            
                            Spacer()
                                .frame(height: 4)
                            
                            Text(roleType)
                                .foregroundColor(.basicWhite)
                                .pretendardFont(family: .Regular, size: 16)
                            
                            Spacer()
                                .frame(height: 12)
                            
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.primaryOrange)
                        
                    }
                    .padding(.horizontal, 20)
                }
            
            Spacer()
                .frame(height: 8)
        }
        .padding(.horizontal , 20)
        
    }
}


#Preview {
    CoreMemberMainView(store: Store(initialState: CoreMember.State(), reducer: {
        CoreMember()
    }))
}
