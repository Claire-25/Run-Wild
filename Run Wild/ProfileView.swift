//
//  ProfileView.swift
//  Run Wild
//
//  Created by Claire Li on 10/16/25.
//
import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .padding(.top, 50)
            Text("Your Profile")
                .font(.title2)
                .fontWeight(.bold)
            Text("Track your runs, achievements, and animal shapes here.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}


