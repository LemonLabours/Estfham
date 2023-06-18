import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



struct PlayerNameView: View {
    @Binding var playerName: String
    let startGame: () -> Void

    var body: some View {
        VStack {
            TextField("Player Name", text: $playerName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Start Game") {
                startGame()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct PlayerNameView_Previews: PreviewProvider {
    @State static var playerName = "Player 1"
    
    static var previews: some View {
        PlayerNameView(playerName: $playerName) {}
    }
}
