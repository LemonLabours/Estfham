import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct JoinQuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var quizId = ""
    @State private var quiz: Quiz? // Replace with your Quiz model
    var firestoreManager = FirestoreManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Join a Quiz")
                .font(.largeTitle)
                .fontWeight(.bold)
                
            TextField("Enter Quiz ID", text: $quizId, onCommit: {
                fetchQuiz()
            })
            .frame(width: 360)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            NavigationLink(destination: QuizView(quiz: quiz), isActive: .constant(quiz != nil)) {
                EmptyView()
            }
            
            Button(action: {
                fetchQuiz()
            }) {
                Text("Join")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
            }
        }
        .navigationBarTitle("", displayMode: .inline) // Empty title to remove the default back button text
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .navigationBarItems(leading: backButton) // Add the custom back button
        
        .padding()
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
                .font(.headline)
        }
    }
    
    private func fetchQuiz() {
        firestoreManager.fetchQuiz(quizId: quizId) { (quiz, error) in
            if let quiz = quiz {
                self.quiz = quiz
            } else if let error = error {
                print("Error fetching quiz: \(error)")
            }
        }
    }
}

struct JoinQuizView_Previews: PreviewProvider {
    static var previews: some View {
        JoinQuizView()
    }
}
