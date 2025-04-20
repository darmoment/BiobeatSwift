//
//  UserControlled.swift
//  Biobeat Watch App
//
//  Created by Darien on 4/8/25.
//

import SwiftUI
import Combine
let firebaseSender = FirebaseSender()

enum VoteState {
    case none
    case upvoted
    case downvoted
}

class UserControlled: ObservableObject {
    @Published var voteState: VoteState = .none
    @Published var voteCount: Int = 0

    func upvote() {
        switch voteState {
        case .none:
            voteCount += 1
            voteState = .upvoted
        case .upvoted:
            voteCount -= 1
            voteState = .none
        case .downvoted:
            voteCount += 2
            voteState = .upvoted
        }
    }

    func downvote() {
        switch voteState {
        case .none:
            voteCount -= 1
            voteState = .downvoted
        case .downvoted:
            voteCount += 1
            voteState = .none
        case .upvoted:
            voteCount -= 2
            voteState = .downvoted
        }
    }
}

struct UserControlledView: View {
    @StateObject private var userControl = UserControlled()

    var body: some View {
        VStack {
            Text("Votes: \(userControl.voteCount)")
                .font(.headline)

            HStack {
                Button(action: {
                    userControl.upvote()
                    sendVote()
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(userControl.voteState == .upvoted ? .green : .gray)
                }

                Button(action: {
                    userControl.downvote()
                    sendVote()
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(userControl.voteState == .downvoted ? .red : .gray)
                }
            }
        }
    }
    
    private func sendVote() {
        firebaseSender.sendVote(
                    voteCount: userControl.voteCount,
                    voteState: userControl.voteState
                )
    }
    
}

#Preview {
    UserControlledView()
}



