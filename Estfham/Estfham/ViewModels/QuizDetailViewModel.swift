import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


struct QuestionCardView: View {
    let questionIndex: Int
    let question: Question

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Q\(questionIndex + 1): \(question.questionText)")
                .font(.headline)
                .fontWeight(.bold)
            Divider()
                .padding(.horizontal)
                .frame(width: 260)
            ForEach(question.answers.indices, id: \.self) { index in
                let answer = question.answers[index]
                Text(answer)
                    .font(.subheadline)
                    .foregroundColor(index == question.correctAnswerIndex ? .green : .black)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}



struct ScoreboardRowView: View {
    let result: StudentResult
    
    var body: some View {
        HStack {
     
            Text("\(result.userName) :")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("\(result.studentScore)")
                .font(.headline)
                .fontWeight(.bold)
        }
      
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding(.horizontal,40)
    
    }
}

struct ScoreboardRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardRowView(result: StudentResult(studentScore: 80, userName: "John Doe"))
    }
}
