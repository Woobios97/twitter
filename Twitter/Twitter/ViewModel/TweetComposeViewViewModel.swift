//
//  TweetComposeViewViewModel.swift
//  Twitter
//
//  Created by 김우섭 on 10/21/23.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissComposer: Bool = false
    var tweetContent: String = ""
    private var user: TwitterUser?
    
    // 현재 로그인한 사용자의 ID를 가져와 해당 사용자의 데이터를 데이터베이스에 검색
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUser(retreive: userID)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] twitterUser in
                self?.user = twitterUser
            }
            .store(in: &subscriptions)
    }
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    // 사용자 정보와 트윗 내용을 기반으로 새로운 트윗 객체를 생성
    func dispatchTweet() {
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorID: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweet(dispatch: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: {[weak self] state in
                self?.shouldDismissComposer = state
            }
            .store(in: &subscriptions)
    }
}
