import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()

    @Published var games = [Game]()

    func fetchGames() {
        db.collection("games").addSnapshotListener { (snapshot, error) in
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
        do {
            let _ = try db.collection("games").addDocument(from: game)
            completion(true, nil)
        } catch let error {
            print("Error writing game to Firestore: \(error)")
            completion(false, error)
        }
    }
}

