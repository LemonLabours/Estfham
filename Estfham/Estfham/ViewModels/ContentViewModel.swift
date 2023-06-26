import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct WelcomeView: View {
    @Binding var userName: String

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 220)
            Text("Hi, \(userName) ")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            Text(" Create custom quizzes to test your friends, \nor join a quiz created by someone else for \nan added challenge. ")
                .padding(.vertical)
            Text("\nIt's all about learning and having fun !")
                .bold()
            
          Spacer()
                .frame(height: 100)
            NavigationLink(destination: MyQuizzesView()) {
                ActionButton(title: "Share a Quiz")
            }
            .padding(.bottom, 10)

            NavigationLink(destination: JoinQuizView()) {
                ActionButton(title: "Take a Quiz")
            }
        }
        .padding(.vertical)
        .padding()
        
    }
}




struct UserNameInputView: View {
    @Binding var tempUserName: String
    @Binding var userName: String
    var saveUserName: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Your Name")
                .font(.title)
                .fontWeight(.bold)

            TextField("Name", text: $tempUserName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                self.userName = tempUserName
                saveUserName()
            }) {
                ActionButton(title: "Save")
            }
        }
    }
}
struct UserNameInputView_Previews: PreviewProvider {
    @State static var tempUserName = ""
    @State static var userName = ""

    static var previews: some View {
        UserNameInputView(tempUserName: $tempUserName, userName: $userName, saveUserName: {})
    }
}

struct ActionButton: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity) // This will make the button's width to extend as much as possible
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // This adds a gradient background from blue to purple
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 3) // This will add a shadow with a radius of 7 and an offset of x: 0, y: 3
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding(.horizontal)
    }
}
