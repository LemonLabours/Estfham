import SwiftUI

struct Intro: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var lottieAnimationName: String
    var color: Color
    var offset: CGSize = .zero
}
