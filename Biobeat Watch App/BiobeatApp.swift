//
//  BiobeatApp.swift
//  Biobeat Watch App
//
//  Created by Darien on 4/8/25.
//

import SwiftUI
import FirebaseCore

@main
struct Biobeat_Watch_AppApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainMenuView()
        }
    }
}
