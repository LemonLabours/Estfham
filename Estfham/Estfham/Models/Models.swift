
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {
    @DocumentID var id: String?
    var gameName: String
    var gameQuestions: [Question]
    var players: [String]
    var creatorUserId: String  // New field for the user ID of the game's creator
}
struct Question: Codable {
    var questionText: String
    var questionAnswers: [String]
    var correctAnswerIndex: Int
    var timer: String
}
struct User: Identifiable {
    @DocumentID var id: String?
    let displayName: String
    let email: String
}
