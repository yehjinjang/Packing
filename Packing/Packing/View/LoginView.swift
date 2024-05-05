//
//  RegisterationView.swift
//  Packing
//
//  Created by 장예진 on 4/30/24.
//


import SwiftUI
import AuthenticationServices

// MARK: Logout 기능 추가
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isMainViewActive = false
    @State private var showingAlert = false
    @State private var isNavigated = false // 네비게이션 발생을 한 번만 허용하기 위한 상태

    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainColor").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("여행에 딱 필요한 짐을 쌀 땐")
                        .font(Font.custom("NanumSquareOTFB", size: 15))
                    Text("Packing")
                        .font(Font.custom("Graduate-Regular", size: 50))
                        .foregroundStyle(Color(hex: 0x566375))
                        .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    
                    if authViewModel.state == .signedIn {
                        // 로그인 성공 시, 환영 메시지와 시작하기 버튼 표시
                        if let username = authViewModel.username {
                            Text("Hello, \(username)")
                                .padding()
                        }
                        Button("시작하기") {
                            isMainViewActive = true
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        
                        // 로그아웃 버튼 추가
                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                    } else {
                        loginButtons
                    }
                    Spacer()
                }
                .navigationDestination(isPresented: $isMainViewActive) {
                    OnboardingView()
                }
                .alert("Login Error", isPresented: $showingAlert, presenting: authViewModel.errorMessage) { error in
                    Button("OK", role: .cancel) { }
                }
//                .onChange(of: authViewModel.state) { _, _ in
//                    if authViewModel.state == .signedIn {
//                        isMainViewActive = true
//                        isNavigated = true
                .onChange(of: authViewModel.state) { newState, _ in
                    if newState == .signedIn && !isNavigated {
                        isMainViewActive = true
                        isNavigated = true
                    }
                }
            }
        }
        .onAppear {
            isMainViewActive = false
            authViewModel.restorePreviousSignIn()
        }
    }
    
    var loginButtons: some View {
        VStack(spacing: 15) {
            Button(action: {
                authViewModel.login()
            }) {
                HStack {
                    Image("googleIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text("Sign in with Google")
                        .foregroundColor(.black)
                        .font(.system(size:18))
                }
                .frame(width: 320, height: 18)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            SignInWithAppleButton(.signIn,
                                  onRequest: { request in
                                      request.requestedScopes = [.fullName, .email]
                                  },
                                  onCompletion: { result in
                                      switch result {
                                      case .success(_):
                                          isMainViewActive = true
                                      case .failure(let error):
                                          authViewModel.errorMessage = error.localizedDescription
                                          showingAlert = true
                                      }
                                  })
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
        }
    }
}



//struct LoginView: View {
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
//    @State private var isOnboardingActive = false
//    @State private var showingAlert = false
//    
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color("mainColor").edgesIgnoringSafeArea(.all)
//                VStack {
//                    Spacer()
//                    Image("logo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50, height: 50)
//                    Text("여행에 딱 필요한 짐을 쌀 땐")
//                        .font(Font.custom("NanumSquareOTFB", size: 15))
//                    Text("Packing")
//                        .font(Font.custom("Graduate-Regular", size: 50))
//                        .foregroundStyle(Color(hex: 0x566375))
//                        .shadow(color: .gray, radius: 2, x: 0, y: 1)
//                    //                        .bold()
//                    Spacer()
//                    
//                    loginButtons
//                    Spacer()
//                }
//                .navigationDestination(isPresented: $isOnboardingActive) {
//                    OnboardingView()
//                }
//                .alert("Login Error", isPresented: $showingAlert, presenting: authViewModel.errorMessage) { error in
//                    Button("OK", role: .cancel) { }
//                }
//                .onChange(of: authViewModel.state) { _, _ in
//                    if authViewModel.state == .signedIn {
//                        isOnboardingActive = true
//                    }
//                }
//            }
//        }
//        .onAppear {
//            authViewModel.restorePreviousSignIn()
//        }
//    }
//    
//    var loginButtons: some View {
//        VStack(spacing: 15) {
//            if authViewModel.state == .signedIn {
//                // 로그아웃 버튼 표시
//                Button("Logout") {
//                    authViewModel.logout()
//                }
//                .frame(width: 320, height: 30)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .padding()
//            } else {
//                // 로그인 버튼들 표시
//                Button(action: {
//                    authViewModel.login()
//                }) {
//                    HStack {
//                        Image("googleIcon")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 22, height: 22)
//                        Text("Sign in with Google")
//                            .foregroundColor(.black)
//                            .font(.system(size:18))
//                    }
//                    .frame(width: 320, height: 18)
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                
//                SignInWithAppleButton(.signIn,
//                                      onRequest: { request in
//                    request.requestedScopes = [.fullName, .email]
//                },
//                                      onCompletion: { result in
//                    switch result {
//                    case .success(_):
//                        isOnboardingActive = true
//                    case .failure(let error):
//                        authViewModel.errorMessage = error.localizedDescription
//                        showingAlert = true
//                    }
//                })
//                .signInWithAppleButtonStyle(.black)
//                .frame(height: 50)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .padding(.horizontal)
//            }
//        }
//    }
//}

#Preview {
    LoginView()
}