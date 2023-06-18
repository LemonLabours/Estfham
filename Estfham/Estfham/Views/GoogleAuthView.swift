
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseCore

struct GoogleAuthView: View {
    @StateObject private var vm = GoogleAuthViewModel()
    @State private var isActive = false
    
    init() {
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
              
                VStack {
               
                    Divider()
                        .padding(30)
                    
                    Button(action: {
                        vm.signInWithGoogle()
                    }, label: {
                        HStack {
                        
                        
                            Text("اكمل التسجيل بحسابك في قوقل")
                                .foregroundColor(.black)
                            
                                .bold()
                                .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                    })
                }
                .navigationBarTitle("", displayMode: .inline)
                .padding(.top, -84) // Adjust the value to remove the space
                
                NavigationLink(destination: ContentView(), isActive: $isActive) {
                    EmptyView()
                }
                .hidden()
            }
            .onReceive(vm.$isLoginSuccessed) { success in
                if success {
                    isActive = true
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView()
    }
}
