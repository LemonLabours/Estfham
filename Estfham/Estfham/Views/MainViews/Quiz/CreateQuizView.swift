import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateQuizView: View {
    @State private var quizName = ""
    @State private var questionText = ""
    @State private var answer1 = ""
    @State private var answer2 = ""
    @State private var answer3 = ""
    @State private var answer4 = ""
    @State private var correctAnswerIndex: Int?
    @State private var questions = [Question]()
    
    var firestoreManager = FirestoreManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Quiz Creator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.top, .bottom], 20)
                    
                    TextField("Quiz Name", text: $quizName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Add Question")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        TextField("Question", text: $questionText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Answers")
                                .font(.headline)
                            
                            AnswerInputField(answer: $answer1, number: 1, correctAnswerIndex: $correctAnswerIndex)
                            AnswerInputField(answer: $answer2, number: 2, correctAnswerIndex: $correctAnswerIndex)
                            AnswerInputField(answer: $answer3, number: 3, correctAnswerIndex: $correctAnswerIndex)
                            AnswerInputField(answer: $answer4, number: 4, correctAnswerIndex: $correctAnswerIndex)
                        }
                        .padding(.bottom)
                        
                        Button(action: addQuestion) {
                            Text("Add Question")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
                        }
                        .disabled(questionText.isEmpty || answer1.isEmpty || answer2.isEmpty || answer3.isEmpty || answer4.isEmpty || correctAnswerIndex == nil)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Added Questions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(questions.indices, id: \.self) { index in
                            CardView(question: questions[index], questionNumber: index + 1)
                                .padding(.vertical, 5)
                        }
                    }
                    .padding()
                    
                    Button(action: createQuiz) {
                        Text("Create Quiz")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
                    }
                    .padding()
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
    
    private func addQuestion() {
        let answers = [answer1, answer2, answer3, answer4].filter { !$0.isEmpty }
        if let correctAnswerIndex = correctAnswerIndex, !questionText.isEmpty, correctAnswerIndex < answers.count {
            let newQuestion = Question(questionText: questionText, answers: answers, correctAnswerIndex: correctAnswerIndex)
            questions.append(newQuestion)
            clearFields()
        }
    }
    
    private func clearFields() {
        questionText = ""
        answer1 = ""
        answer2 = ""
        answer3 = ""
        answer4 = ""
        correctAnswerIndex = nil
    }
    
    private func createQuiz() {
        let userId = Auth.auth().currentUser?.uid ?? "unknownUser"  // Fetch the current user's ID
        let quiz = Quiz(authorId: userId, quizName: quizName, questions: questions, studentResults: [])
        
        firestoreManager.createQuiz(quiz: quiz) { (quizId, error) in
            if let error = error {
                print(error)
            } else if let quizId = quizId {
                print("Quiz Created Successfully with ID: \(quizId)")
                // Now the quizId can be shared with students as a pin.
            }
        }
    }
}

struct CreateQuizView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQuizView()
    }
}

struct CardView: View {
    let question: Question
    let questionNumber: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Question \(questionNumber)")
                .font(.headline)
                .padding(.horizontal)
            
            Text(question.questionText)
                .font(.subheadline)
                .padding(.horizontal)
            
            ForEach(question.answers.indices, id: \.self) { index in
                Text(question.answers[index])
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct AnswerInputField: View {
    @Binding var answer: String
    let number: Int
    @Binding var correctAnswerIndex: Int?
    
    var body: some View {
        HStack {
            TextField("Answer \(number)", text: $answer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                correctAnswerIndex = number - 1
            }) {
                Image(systemName: correctAnswerIndex == number - 1 ? "checkmark.square" : "square")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
