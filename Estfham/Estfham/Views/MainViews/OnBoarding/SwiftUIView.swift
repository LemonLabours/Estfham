import SwiftUI

struct vie: View {
    
    
    var body: some View {

                ZStack {
                    VStack {
                        Spacer()
                        
                        LottieView(name: Constants.quiz, size: CGSize(width: 250, height: 250))
                        
                        Spacer()
                    }
                    
                }
        }
    }



struct vie_Previews: PreviewProvider {
    static var previews: some View {
        vie()
    }
}
