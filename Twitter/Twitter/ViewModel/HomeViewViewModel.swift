//
//  HomeViewViewModel.swift
//  Twitter
//
//  Created by 김우섭 on 10/16/23.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscription: Set<AnyCancellable> = []
    
    // 현재 로그인한 유저 정보 가져오기
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retreive: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscription)
    }
    
    // 해당 사용자의 트윗 가져오기
    func fetchTweets() {
        guard let userID = user?.id else { return }
        DatabaseManager.shared.collectionTweets(retreiveTweets: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] retreiveTweets in
                self?.tweets = retreiveTweets
            }
            .store(in: &subscription)
    }
}
