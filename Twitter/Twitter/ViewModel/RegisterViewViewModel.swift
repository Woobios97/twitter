//
//  RegisterViewViewModel.swift
//  Twitter
//
//  Created by 김우섭 on 10/15/23.
//

import Foundation
import Firebase
import Combine

final class RegisterViewViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegisterationFormVaild: Bool = false   // ID와 비밀번호의 유효성 검사
    @Published var user: User?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func vaildRegisterationForm() {
        guard let email = email,
              let password = password else {
            isRegisterationFormVaild = false
            return
        }
        isRegisterationFormVaild = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // 계정 생성 요청
    func createUser() {
        guard let email = email,
              let password = password else { return }
        print("등록완료")
        AuthManager.shared.registerUser(with: email, password: password)
            .sink {  _ in
                
            } receiveValue: { [weak self] user in   // Firebase 응답처리
                self?.user = user
            }
            .store(in: &subscriptions)
    }
}
