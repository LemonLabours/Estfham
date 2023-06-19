import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MultipeerConnectivity

struct GameListView: View {
    @ObservedObject var gameManager: GameManager
    let games: [Game]

    var body: some View {
        NavigationView {
            VStack {
                List(games) { game in
                    NavigationLink(destination: GameView(gameManager: gameManager, game: game)) {
                        Text(game.gameName)
                    }
                }
                .navigationTitle("Games")

                HStack {
                    Button("Host Game") {
                        gameManager.hostGame()
                    }

                    Button("Join Game") {
                        gameManager.joinGame()
                    }
                }
                .alert(isPresented: $gameManager.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(gameManager.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        let gameManager = GameManager()
        let games = [Game(gameName: "Game 1", gameQuestions: [Question(questionText: "What is SwiftUI?", questionAnswers: ["A UI Framework", "A game"], correctAnswerIndex: 0, timer: "30")], players: ["Player1"], creatorUserId: "mockUserId")]
        GameListView(gameManager: gameManager, games: games)
    }
}
