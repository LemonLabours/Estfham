import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct QuizDetailView: View {
    var quiz: Quiz
    @State private var showingShareSheet = false
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quiz.quizName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 5)
            
            TabView(selection: $currentIndex) {
                ForEach(quiz.questions.indices, id: \.self) { index in
                    QuestionCardView(questionIndex: index, question: quiz.questions[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)
            
            HStack {
                Spacer()
                Text("\(currentIndex + 1) / \(quiz.questions.count)")
                    .font(.caption)
                Spacer()
            }
            
            Divider()
                .frame(minHeight: 3)
                .overlay(Color.blue)
                .padding(.vertical, 2)
            
            HStack {
                Spacer()
                Image(systemName: "trophy.fill")
                    .foregroundColor(Color.yellow)
                Text("Scores")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView {
                ForEach(quiz.studentResults, id: \.self) { result in
                    ScoreboardRowView(result: result)
                }
            }
            
            Spacer()
            
            Button(action: {
                self.showingShareSheet = true
            }) {
                Text("Share Quiz Pin")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: [quiz.id ?? ""])
            }
        }
        .padding()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct QuizDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuizDetailView(quiz: Quiz(authorId: "", quizName: "", questions: [], studentResults: []))
    }
}
