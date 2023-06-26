import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct QuizView: View {
    let quiz: Quiz?
    @State private var selectedAnswers: [Int] = []
    @State private var selectedQuestionAnswerIndex: [Int: Int] = [:] // Store selected answer for each question
    @State private var isQuizCompleted = false
    @State private var score = 0
    var firestoreManager = FirestoreManager()
    
    var body: some View {
        ScrollView {
            VStack {
                if let quiz = quiz {
                    Text(quiz.quizName)
                        .font(.largeTitle)
                        .padding()
                    
                    ForEach(quiz.questions.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(quiz.questions[index].questionText)
                                .font(.headline)
                            ForEach(quiz.questions[index].answers.indices, id: \.self) { answerIndex in
                                Button(action: {
                                    selectAnswer(questionIndex: index, answerIndex: answerIndex)
                                }) {
                                    Text(quiz.questions[index].answers[answerIndex])
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedQuestionAnswerIndex[index] == answerIndex ? Color.green : Color.EPink) // Color change for selected answer
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .padding(.vertical, 5)
                                }
                                .disabled(isQuizCompleted)
                            }
                        }
                        .padding()
                    }
                    
                    if isQuizCompleted {
                        Text("Your Score: \(score)")
                            .font(.title)
                            .padding()
                    }
                    
                    Button(action: submitQuiz) {
                        Text(isQuizCompleted ? "Retake Quiz" : "Submit Quiz")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
                    }.padding()
                    .disabled(isQuizCompleted)
                }
            }
            .onAppear(perform: {
                if let quizId = quiz?.id {
                    loadStudentResult(quizId: quizId)
                }
            })
        }
    }
    
    func selectAnswer(questionIndex: Int, answerIndex: Int) {
        if let _ = quiz {
            selectedQuestionAnswerIndex[questionIndex] = answerIndex // Store selected answer
            if selectedAnswers.count > questionIndex {
                selectedAnswers[questionIndex] = answerIndex
            } else {
                selectedAnswers.append(answerIndex)
            }
        }
    }
    
    func submitQuiz() {
        if let quiz = quiz {
            score = firestoreManager.calculateScore(quiz: quiz, studentAnswers: selectedAnswers)
            isQuizCompleted = true
            
            if let userId = Auth.auth().currentUser?.uid, let quizId = quiz.id {
                firestoreManager.fetchUser(userId: userId) { user, error in
                    if let user = user {
                        let studentResult = StudentResult(studentScore: score, userName: user.userName)
                        firestoreManager.saveStudentResult(quizId: quizId, studentResult: studentResult) { error in
                            if let error = error {
                                print("Error saving student result: \(error)")
                            } else {
                                print("Student result saved successfully.")
                            }
                        }
                    } else if let error = error {
                        print("Error fetching user: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func loadStudentResult(quizId: String) {
        if let userId = Auth.auth().currentUser?.uid {
            firestoreManager.fetchQuiz(quizId: quizId) { fetchedQuiz, error in
                if let fetchedQuiz = fetchedQuiz {
                    let studentResult = fetchedQuiz.studentResults.first { result in
                        result.userName == userId
                    }
                    if let result = studentResult {
                        score = result.studentScore
                        isQuizCompleted = true
                    }
                } else if let error = error {
                    print("Error fetching student result: \(error)")
                }
            }
        }
    }

}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(quiz: Quiz(authorId: "", quizName: "", questions: [], studentResults: []))
    }
}
