import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddGameView: View {
    @ObservedObject var firestoreManager = FirestoreManager()

    @State var gameName = ""
    @State var players: [String] = ["", ""]
    @State var questionText = ""
    @State var answers: [String] = ["", "", "", ""]
    @State var correctAnswerIndex = 0
    @State var timer = "30"

    var body: some View {
        VStack {
            TextField("Game Name", text: $gameName)
            
            ForEach(players.indices, id: \.self) { index in
                TextField("Player \(index + 1)", text: $players[index])
            }
            Button("Add Player") {
                players.append("")
            }

            TextField("Question Text", text: $questionText)
            
            ForEach(answers.indices, id: \.self) { index in
                TextField("Answer \(index + 1)", text: $answers[index])
            }
            Button("Add Answer") {
                if answers.count < 4 {
                    answers.append("")
                }
            }

            Picker("Correct Answer", selection: $correctAnswerIndex) {
                Text("Answer 1").tag(0)
                Text("Answer 2").tag(1)
                Text("Answer 3").tag(2)
                Text("Answer 4").tag(3)
            }.pickerStyle(SegmentedPickerStyle())

            TextField("Timer", text: $timer)

            Button("Add Game") {
                let gameQuestion = Question(questionText: questionText, questionAnswers: answers, correctAnswerIndex: correctAnswerIndex, timer: timer)
                
                // Make sure to provide the creatorUserId here
                let game = Game(gameName: gameName, gameQuestions: [gameQuestion], players: players, creatorUserId: Auth.auth().currentUser?.uid ?? "")
                firestoreManager.addGame(game: game) { (success, error) in
                    if let error = error {
                        print("Failed to add game: \(error)")
                    } else {
                        print("Game added successfully")
                    }
                }
            }
        }
        .padding()
    }
}


struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}
