//
//  Run_WildApp.swift
//  Run Wild
//
//  Created by Claire Li on 10/15/25.
//

import SwiftUI

@main
struct Run_WildApp: App {
    @StateObject private var appData = AppData()
    @State private var isLoggedIn = false // <-- track login state

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
                    .environmentObject(appData)
                    .transition(.opacity) // smooth fade
            } else {
                AnimatedLoginView(isLoggedIn: $isLoggedIn) // <-- pass binding
                    .environmentObject(appData)
                    .transition(.opacity)
            }
        }
    }
}
