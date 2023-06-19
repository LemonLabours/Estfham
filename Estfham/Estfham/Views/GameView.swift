import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MultipeerConnectivity

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    let game: Game

    @State private var currentPlayer: String = ""
    @State private var isAnswerCorrect: Bool? = nil
    @State private var showAnswers: Bool = false
    @State private var showingErrorAlert = false

    var currentQuestion: Question? {
        if game.gameQuestions.indices.contains(gameManager.currentQuestionIndex) {
            return game.gameQuestions[gameManager.currentQuestionIndex]
        }
        return nil
    }

    var body: some View {
        VStack {
            // Current player
            Text("Current Player: \(currentPlayer)")
                .font(.subheadline)
                .padding()

            // Timer
            Text("Time Remaining: \(gameManager.remainingTime)")
                .font(.headline)
                .padding()

            Divider()

            // Question
            if let question = currentQuestion {
                Text(question.questionText)
                    .font(.headline)
                    .padding()

                // Answers grid
                if showAnswers {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(question.questionAnswers.indices, id: \.self) { index in
                            Button(action: {
                                gameManager.submitAnswer(answerIndex: index)
                                isAnswerCorrect = (index == question.correctAnswerIndex)
                            }) {
                                Text(question.questionAnswers[index])
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .disabled(gameManager.remainingTime <= 0)
                        }
                    }
                    .padding()
                }
            } else {
                Text("No Question Found")
                    .font(.headline)
                    .padding()
            }

            Spacer()

            // "Next Question" button
            if gameManager.currentQuestionIndex + 1 < game.gameQuestions.count {
                Button("Next Question") {
                    gameManager.nextQuestion()
                    isAnswerCorrect = nil
                    currentPlayer = ""
                    showAnswers = false
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .background(
            Color(
                (isAnswerCorrect == nil && gameManager.remainingTime > 0) ? .white :
                isAnswerCorrect == true ? .green : .red
            )
        )
        .animation(.default, value: isAnswerCorrect)
        .onAppear {
            startGame()
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text(gameManager.error?.localizedDescription ?? "Unknown Error"), dismissButton: .default(Text("OK")))
        }
    }

    func startGame() {
        gameManager.startGame(game: game, playerName: currentPlayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 2)) {
                chooseRandomPlayer()
            }
        }
    }

    func chooseRandomPlayer() {
        gameManager.chooseRandomPlayer()
        currentPlayer = gameManager.currentPlayerName ?? ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 2)) {
                showAnswers = true
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let gameManager = GameManager()
        let game = Game(gameName: "Game 1", gameQuestions: [Question(questionText: "What is SwiftUI?", questionAnswers: ["A UI Framework", "A game", "A language", "An IDE"], correctAnswerIndex: 0, timer: "30")], players: ["Player1", "Player2"], creatorUserId: "mockUserId")
        GameView(gameManager: gameManager, game: game)
            .environmentObject(gameManager) // Add this line to pass the gameManager instance
    }
}
