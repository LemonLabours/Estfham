import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    var id: String? 
    var userName: String
    var createdQuizId: [String]
    var completedQuizId: [String]
}

struct Quiz: Identifiable, Codable {
    @DocumentID var id: String? 
    let authorId: String
    let quizName: String
    var questions: [Question]
    var studentResults: [StudentResult]

    enum CodingKeys: String, CodingKey {
        case id
        case authorId
        case quizName
        case questions
        case studentResults
    }
}

struct Question: Codable {
    let questionText: String
    var answers: [String]
    let correctAnswerIndex: Int
}

struct StudentResult: Codable, Hashable {
    let studentScore: Int
    let userName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userName)
    }
    
    static func == (lhs: StudentResult, rhs: StudentResult) -> Bool {
        return lhs.userName == rhs.userName && lhs.studentScore == rhs.studentScore
    }
}

