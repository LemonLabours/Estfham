import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    var size: CGSize
    
    init(name: String,
         loopMode: LottieLoopMode = .playOnce,
         animationSpeed: CGFloat = 1,
         size: CGSize = CGSize(width: 200, height: 200)) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.size = size
    }
    
    func makeUIView(context: Context) -> some UIView {
        // Create a UIView
        let view = UIView()
        
        // Create LottieAnimationView
        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        animationView.contentMode = .scaleAspectFit

        // Add animationView to the view
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: size.height),
            animationView.widthAnchor.constraint(equalToConstant: size.width),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // This is not needed anymore since the size is set in makeUIView(context:)
    }
}
