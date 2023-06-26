import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct ContentView: View {
    @State private var userName = ""
    @State private var tempUserName = ""
    @State private var isLoading = true

    var firestoreManager = FirestoreManager()

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    ProgressView()
                        .navigationTitle("Loading...")
                } else if !userName.isEmpty {
                    WelcomeView(userName: $userName)
                        .navigationTitle("Quiz App")
                } else {
                    UserNameInputView(tempUserName: $tempUserName, userName: $userName, saveUserName: saveUserName)
                        .navigationTitle("Quiz App")
                }
            }
        }
        .onAppear(perform: loadUserName)
    }
    
    func loadUserName() {
        if let userId = Auth.auth().currentUser?.uid {
            firestoreManager.fetchUser(userId: userId) { user, error in
                if let user = user {
                    userName = user.userName
                }
                isLoading = false
            }
        }
    }

    func saveUserName() {
        if let userId = Auth.auth().currentUser?.uid, !userName.isEmpty {
            let user = User(id: userId, userName: userName, createdQuizId: [], completedQuizId: [])

            firestoreManager.saveUser(user: user) { error in
                if error != nil {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }
}

struct WelcomeView: View {
    @Binding var userName: String

    var body: some View {
        VStack {
            Text("Hi, \(userName)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            NavigationLink(destination: MyQuizzesView()) {
                ActionButton(title: "My Quizzes")
            }
            .padding(.bottom, 10)

            NavigationLink(destination: JoinQuizView()) {
                ActionButton(title: "Join a Quiz")
            }
        }
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

struct ActionButton: View {
    var title: String

    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
