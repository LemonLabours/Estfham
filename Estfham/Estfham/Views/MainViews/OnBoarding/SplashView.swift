import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        Group {
            if isActive {
                NavigationView {
                    OnBoardingView()
                        .navigationBarHidden(true)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5))
            } else {
                ZStack {
                    VStack {
                        Spacer()
                        
                        LottieView(name: Constants.quiz, size: CGSize(width: 250, height: 250))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            scale = 0.9
                            opacity = 1.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                opacity = 0.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                isActive = true
                            }
                        }
                    }
                }
                .opacity(opacity)
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
