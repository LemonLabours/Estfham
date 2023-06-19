import Combine
import MultipeerConnectivity
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class GameManager: ObservableObject {
    // Common properties
    @Published var currentGame: Game?
    @Published var currentPlayerName: String?
    @Published var currentQuestionIndex = 0
    @Published var remainingTime = 0
    @Published var isAnswerCorrect = false
    private var timer: Timer?
    
    // Multipeer Connectivity properties
    var players: [MCPeerID] = []
    var host: MCPeerID?
    var isHost = false
    let multipeerManager = MultipeerConnectivityManager()
    
    
    // Alert properties
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var error: Error?
    
    
    // Common methods
    func startGame(game: Game, playerName: String) {
        currentGame = game
        currentPlayerName = playerName
        currentQuestionIndex = 0
        remainingTime = getTimerValue(for: game.gameQuestions[0].timer)
        isAnswerCorrect = false
        startTimer()
    }
    
    func nextQuestion() {
        if let game = currentGame {
            currentQuestionIndex += 1
            
            if currentQuestionIndex < game.gameQuestions.count {
                remainingTime = getTimerValue(for: game.gameQuestions[currentQuestionIndex].timer)
                isAnswerCorrect = false
                startTimer()
            } else {
                endGame()
            }
        }
    }
    
    func submitAnswer(answerIndex: Int) {
        if let game = currentGame, game.gameQuestions.indices.contains(currentQuestionIndex) {
            isAnswerCorrect = (answerIndex == game.gameQuestions[currentQuestionIndex].correctAnswerIndex)
            stopTimer()
        }
    }
    
    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func endGame() {
        currentGame = nil
        currentPlayerName = nil
        currentQuestionIndex = 0
        remainingTime = 0
        isAnswerCorrect = false
        stopTimer()
    }
    
    private func getTimerValue(for timerString: String) -> Int {
        if let timerValue = Int(timerString) {
            return timerValue
        }
        return 0
    }
    
    // Multipeer Connectivity methods
    func hostGame() {
        isHost = true
        multipeerManager.startHosting()
    }
    
    func joinGame() {
        isHost = false
        multipeerManager.joinSession()
    }
    
    // Additional methods related to Multipeer Connectivity
    func invitePeer(peerID: MCPeerID) {
        multipeerManager.invitePeer(peerID: peerID)
    }
    
    func sendDataToPeers(data: Data) {
        multipeerManager.sendData(data: data)
    }
    
    // Handle Multipeer Connectivity Events
    
    func handlePeerConnectionChange(peerID: MCPeerID, isConnected: Bool) {
        if isConnected {
            players.append(peerID)
        } else {
            if let index = players.firstIndex(of: peerID) {
                players.remove(at: index)
            }
        }
    }
    
    func handleReceivedData(data: Data) {
        // Handle received data from other peers
        
        // Convert the received data to the appropriate format
        if let receivedString = String(data: data, encoding: .utf8) {
            // Process the received data
            // Example: Display the received string as an alert message
            showAlert = true
            alertMessage = "Received data: \(receivedString)"
        }
    }
    
    func chooseRandomPlayer() {
        guard let game = currentGame else { return }
        
        currentPlayerName = game.players.randomElement()
    }
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
}
