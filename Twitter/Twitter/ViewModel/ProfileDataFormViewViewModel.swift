//
//  ProfileDataFormViewViewModel.swift
//  Twitter
//
//  Created by 김우섭 on 10/16/23.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth
import FirebaseStorage

final class ProfileDataFormViewViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    @Published var imageData: UIImage?
    @Published var isFormValid: Bool = false // 유효성 검사
    @Published var url: URL?
    @Published var error: String = ""
    
    func validateUserProfileForm() {
        guard let displayName = displayName,
              displayName.count > 2,
              let username = username,
              username.count > 2,
              let bio = bio,
              bio.count > 2,
              imageData != nil else {
            isFormValid = false
            return
        }
        isFormValid = true
    }
    
    // 사진을 업로드할 함수
    func uploadAvatar() {
        let randomID = UUID().uuidString    // 고유한 사용자 ID를 생성한다.
        guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }  // UIImage를 JPEG 형식의 데이터로 변환한다.
        let metaData = StorageMetadata()    // 객체를 생성하여 이미지의 메타데이터를 설정한다.
        metaData.contentType = "images/jpeg" // 이미지의 컨텐츠유형을 "images/jpeg"로 설정한다.
        
        // 이미지 데이터와 메타데이터를 Firebase Storage에 업로드한다.
        StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metaData: metaData)
            .flatMap({ metaData in  // 이미지 업로드가 완료되면 함수를 호출하여 업로드된 이미지의 다운로드 URL을 가져온다.
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] url in
                self?.url = url
            }
            .store(in: &subscriptions)
    }
    
}
