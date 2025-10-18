//
//  BottomPanelView.swift
//  Run Wild
//
//  Created by Claire Li on 10/16/25.
//
import SwiftUI

struct BottomPanelView: View {
    @State private var distance = ""
    @State private var selectedShape = 0
    let shapes = ["Bird", "Bunny", "Butterfly", "Shrimp"]
  
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 8)

            // Distance input
            VStack(alignment: .leading) {
                Text("Distance Goal")
                    .font(.headline)
                TextField("Enter miles...", text: $distance)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
            }

            // Shape picker
            VStack(alignment: .leading) {
                Text("Choose Your Shape")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<shapes.count, id: \.self) { index in
                            Button(action: {
                                selectedShape = index
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(selectedShape == index ? Color.blue.opacity(0.3) : Color.gray.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    VStack {
                                        Image(shapes[index])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button("Generate Path") {
                // TODO: connect to PathGenerator
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 20)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(radius: 12)
    }
}
