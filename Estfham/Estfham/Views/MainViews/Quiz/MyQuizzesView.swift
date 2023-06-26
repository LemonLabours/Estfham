import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct MyQuizzesView: View {
    @State private var quizzes: [Quiz] = []
    var firestoreManager = FirestoreManager()
    @State private var isCreateQuizPresented = false
    @State private var selectedQuiz: Quiz?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                if quizzes.isEmpty {
                    Spacer()
                    Text("No quizzes found")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(quizzes) { quiz in
                        Button(action: {
                            self.selectedQuiz = quiz
                        }) {
                            QuizListItemView(quiz: quiz)
                        }
                    }
                    .listStyle(PlainListStyle()) // Set the list style to plain
                    .background(Color.white) // Set the list background color to white
                }
            }
            .padding()
            
            VStack {
                Spacer()
                Button(action: {
                    isCreateQuizPresented = true
                }) {
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
        }.navigationBarBackButtonHidden()
        .navigationBarTitle("My Quizzes", displayMode: .inline) // Set the title display mode to inline
        .navigationBarItems(leading:
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }
        )
        .onAppear {
            fetchQuizzes()
        }
        .sheet(item: $selectedQuiz) { quiz in
            QuizDetailView(quiz: quiz)
        }
        .sheet(isPresented: $isCreateQuizPresented) {
            CreateQuizView()
        }
    }
    
    func fetchQuizzes() {
        if let userId = Auth.auth().currentUser?.uid {
            firestoreManager.fetchUserQuizzes(userId: userId) { quizzes, error in
                if let error = error {
                    print("Error fetching quizzes: \(error)")
                } else if let quizzes = quizzes {
                    self.quizzes = quizzes
                }
            }
        }
    }
}

struct QuizListItemView: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quiz.quizName)
                .font(.headline)
                .foregroundColor(.black)
            
            Text("\(quiz.questions.count) questions")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct MyQuizzesView_Previews: PreviewProvider {
    static var previews: some View {
        MyQuizzesView()
    }
}
