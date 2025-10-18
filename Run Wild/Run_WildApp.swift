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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
        }
    }
}
