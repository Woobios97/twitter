//
//  StorageManager.swift
//  Twitter
//
//  Created by 김우섭 on 10/18/23.
//

import UIKit
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirebaseStorageError: Error {
    case invalidImageID
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    // 주어진 ID에 해당하는 파일의 다운로드 URL을 가져온다.
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FirebaseStorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    // 주어진 이미지 데이터와 메타데이터를 Firebase Storage에 업로드한다.
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
}
