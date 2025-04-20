//
//  BioControlled.swift
//  Biobeat Watch App
//
//  Created by Darien on 4/8/25.
//

import SwiftUI
import HealthKit

struct BioControlledView: View {
    @State private var heartRate: Double = 0
    private let firebaseSender = FirebaseSender()
    private let healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            Text("❤️")
                .font(.largeTitle)
                .bold()
        }
        .onAppear {
            requestAuthorization()
        }
    }

    private func requestAuthorization() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        let types: Set = [heartRateType]
        healthStore.requestAuthorization(toShare: nil, read: types) { success, error in
            if success {
                startHeartRateQuery()
            } else if let error = error {
                print("Authorization error: \(error)")
            }
        }
    }

    private func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { _, samples, _, _, _ in
            self.handle(samples)
        }

        query.updateHandler = { _, samples, _, _, _ in
            self.handle(samples)
        }

        healthStore.execute(query)
    }

    private func handle(_ samples: [HKSample]?) {
        guard let quantitySamples = samples as? [HKQuantitySample] else { return }

        if let latest = quantitySamples.last {
            let bpm = latest.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self.heartRate = bpm
                print("Heart Rate Updated: \(bpm) bpm")
                firebaseSender.sendHeartRate(bpm: bpm)
            }
        }
    }
}

#Preview {
    BioControlledView()
}
