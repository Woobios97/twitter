//
//  ProfileDataFormViewViewModel.swift
//  Twitter
//
//  Created by 김우섭 on 10/16/23.
//

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
