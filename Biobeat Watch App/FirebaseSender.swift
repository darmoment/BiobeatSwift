//
//  FirebaseSender.swift
//  Biobeat
//
//  Created by Darien on 4/18/25.
//

import Foundation

class FirebaseSender {
    private let apiKey = "i5NnW9HDSrgXcJqdGzV7VlcDE6aJlMcKqGNPmcLa"
    private let projectId = "biobeat-2d01c"

    func sendHeartRate(bpm: Double) {
        guard let url = URL(string: "https://biobeat-2d01c-default-rtdb.firebaseio.com/HeartRates/watch1.json?auth=\(apiKey)") else {
            print("❌ No API Ckey")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let json: [String: Any] = [
            "value": ["doubleValue": bpm],
            "timestamp": ["stringValue": ISO8601DateFormatter().string(from: Date())]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🔥 Firestore send error: \(error.localizedDescription)")
            } else {
                print("✅ Sent to Firestore")
            }
        }.resume()
    }
    
    func sendVote(voteCount: Int, voteState: VoteState) {
        guard let url = URL(string: "https://biobeat-2d01c-default-rtdb.firebaseio.com/Votes/watch1.json?auth=\(apiKey)") else {
            print("❌ Invalid vote Firebase URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let json: [String: Any] = [
            "value": voteCount,
            "state": "\(voteState)",
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("🔥 Firestore vote send error: \(error.localizedDescription)")
            } else {
                print("✅ Vote sent to Firestore")
            }
        }.resume()
    }

}
