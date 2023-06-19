import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


final class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()

    @Published var games = [Game]()

    func fetchGames() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("games").whereField("creatorUserId", isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching games: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            let games = documents.compactMap { queryDocumentSnapshot -> Game? in
                return try? queryDocumentSnapshot.data(as: Game.self)
            }
            
            DispatchQueue.main.async {
                self.games = games
                print("Fetched games: \(games)")
            }
        }
    }

    func addGame(game: Game, completion: @escaping (Bool, Error?) -> Void) {
        var gameWithCreator = game
        gameWithCreator.creatorUserId = Auth.auth().currentUser?.uid ?? ""
        do {
            let _ = try db.collection("games").addDocument(from: gameWithCreator)
            completion(true, nil)
        } catch let error {
            print("Error writing game to Firestore: \(error)")
            completion(false, error)
        }
    }
}
