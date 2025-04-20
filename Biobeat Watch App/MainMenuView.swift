//
//  MainMenuView.swift
//  Biobeat Watch App
//
//  Created by Darien on 4/8/25.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Heart Rate Monitor") {
                    BioControlledView()
                }
                
                NavigationLink("Vote System") {
                    UserControlledView()
                }
            }
            .navigationTitle("Main Menu")
        }
    }
}

#Preview {
    MainMenuView()
}
