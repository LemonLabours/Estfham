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
                Color.EPurple
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .edgesIgnoringSafeArea(.all)
                
       
                LottieView(name: Constants.home, size: CGSize(width: 300, height: 300))
                    .padding(.bottom, 400)
                
                RoundedRectangle(cornerRadius: 35)
                    .padding(.top, 300)
                    .foregroundColor(.white)
                    .frame(width: 400, height: 900 )
                    .presentationDetents([.medium, .fraction((0.40))])
                
                Spacer()
                
                VStack{
                    
                    if isLoading {
                        ProgressView()
                           
                    } else if !userName.isEmpty {
                        WelcomeView(userName: $userName)
                            
                    } else {
                        UserNameInputView(tempUserName: $tempUserName, userName: $userName, saveUserName: saveUserName)
                          
                    }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
