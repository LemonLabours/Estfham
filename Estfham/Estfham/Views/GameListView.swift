import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct GameListView: View {
    @ObservedObject var gameManager: GameManager
    let games: [Game]
    
    var body: some View {
        NavigationView {
            List(games) { game in
                NavigationLink(destination: GameView(gameManager: gameManager, game: game)) {
                    Text(game.gameName)
                }
            }
            .navigationTitle("Games")
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
