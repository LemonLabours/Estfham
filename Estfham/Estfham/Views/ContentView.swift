import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift



struct ContentView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    @ObservedObject private var gameManager = GameManager()

    @State private var isShowingGameList = false
    @State private var isShowingAddGameView = false

    var body: some View {
        VStack {
            Button("Show Games") {
                self.isShowingGameList = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isShowingGameList) {
                GameListView(gameManager: gameManager, games: firestoreManager.games)
                .onAppear {
                    firestoreManager.fetchGames()
                }
            }

            Button("Add New Game") {
                self.isShowingAddGameView = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isShowingAddGameView) {
                AddGameView(firestoreManager: firestoreManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
