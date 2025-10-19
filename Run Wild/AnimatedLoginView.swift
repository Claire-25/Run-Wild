import SwiftUI

struct AnimatedLoginView: View {
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoggingIn = false
    @State private var animateLeaves = false

    var body: some View {
        ZStack {
            // Solid green background
            Color.green
                .ignoresSafeArea()

            // Floating leaves
            ForEach(0..<8) { i in
                LeafView()
                    .offset(x: CGFloat.random(in: -150...150), y: animateLeaves ? 800 : -200)
                    .animation(
                        Animation.linear(duration: Double.random(in: 6...12))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...4)),
                        value: animateLeaves
                    )
            }

            VStack(spacing: 30) {
                // App title
                VStack {
                    Text("Run Wild")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Connect with nature and your fitness")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 50)

                // Login fields
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("Password", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        } else {
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .padding(.trailing, 15)
                        }
                    }
                }
                .padding(.horizontal, 30)

                // Login button with smooth transition
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isLoggedIn = true
                    }
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [Color.green.opacity(0.8), Color.green],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)

                // Links
                HStack {
                    Button("Forgot Password?") {}
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()

                    Button("Sign Up") {}
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 30)

                Spacer()
            }
        }
        .onAppear { animateLeaves.toggle() }
        .transition(.opacity) // Smooth fade when switching views
    }
}

// MARK: - LeafView
struct LeafView: View {
    @State private var rotation: Double = Double.random(in: 0...360)
    @State private var scale: CGFloat = CGFloat.random(in: 0.5...1.2)

    var body: some View {
        Image(systemName: "leaf.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(Color.green.opacity(0.7))
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.linear(duration: Double.random(in: 4...8)).repeatForever(autoreverses: true)) {
                    rotation += Double.random(in: 90...360)
                }
            }
    }
}

struct AnimatedLoginView_Previews: PreviewProvider {
    @State static var isLoggedIn = false

    static var previews: some View {
        AnimatedLoginView(isLoggedIn: $isLoggedIn)
    }
}
