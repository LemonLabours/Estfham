import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    let db = Firestore.firestore()
    
    var userListener: ListenerRegistration?
    var quizzesListener: ListenerRegistration?
    var quizListener: ListenerRegistration?
    
    func fetchUser(userId: String, completion: @escaping (User?, Error?) -> Void) {
        let docRef = db.collection("users").document(userId)
        
        userListener = docRef.addSnapshotListener { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: User.self)
                }
            }
            switch result {
            case .success(let user):
                completion(user, nil)
            case .failure(let error):
                print("Error decoding user: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func fetchQuiz(quizId: String, completion: @escaping (Quiz?, Error?) -> Void) {
        let docRef = db.collection("quizzes").document(quizId)
        
        docRef.addSnapshotListener { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                do {
                    let quiz = try document.data(as: Quiz.self)
                    completion(quiz, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Quiz document not found"])
                completion(nil, error)
            }
        }
    }
    func createQuiz(quiz: Quiz, completion: @escaping (String?, Error?) -> Void) {
        do {
            var newQuiz = quiz
            let quizRef = try db.collection("quizzes").addDocument(from: newQuiz)
            newQuiz.id = quizRef.documentID
            completion(newQuiz.id, nil)
        } catch let error {
            print("Error writing quiz to Firestore: \(error)")
            completion(nil, error)
        }
    }
    
    func saveStudentResult(quizId: String, studentResult: StudentResult, completion: @escaping (Error?) -> Void) {
        do {
            let studentResultData = try Firestore.Encoder().encode(studentResult)
            let docRef = db.collection("quizzes").document(quizId)
            docRef.updateData([
                "studentResults": FieldValue.arrayUnion([studentResultData])
            ]) { error in
                completion(error)
            }
        } catch {
            print("Error encoding student result: \(error)")
            completion(error)
        }
    }
    
    func calculateScore(quiz: Quiz, studentAnswers: [Int]) -> Int {
        var score = 0
        for (index, question) in quiz.questions.enumerated() {
            if studentAnswers.count > index && studentAnswers[index] == question.correctAnswerIndex {
                score += 1
            }
        }
        return score
    }
    
    func saveUser(user: User, completion: @escaping (Error?) -> Void) {
        if let userId = user.id {
            do {
                try db.collection("users").document(userId).setData(from: user)
                completion(nil)
            } catch let error {
                completion(error)
            }
        } else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
        }
    }
    
    func fetchUserQuizzes(userId: String, completion: @escaping ([Quiz]?, Error?) -> Void) {
        let quizzesCollection = db.collection("quizzes")
        
        quizzesListener = quizzesCollection.whereField("authorId", isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var quizzes: [Quiz] = []
            
            for document in snapshot!.documents {
                do {
                    let quiz = try document.data(as: Quiz.self)
                    quizzes.append(quiz)
                } catch {
                    print("Error decoding quiz: \(error)")
                }
            }
            
            completion(quizzes, nil)
        }
    }
    
    func listenForQuizChanges(quizId: String, completion: @escaping (Quiz?, Error?) -> Void) {
        let docRef = db.collection("quizzes").document(quizId)
        
        quizListener = docRef.addSnapshotListener { (document, error) in
            let result = Result {
                try document.flatMap {
                    try $0.data(as: Quiz.self)
                }
            }
            switch result {
            case .success(let quiz):
                completion(quiz, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func stopListeningForQuizChanges() {
        quizListener?.remove()
    }
    
    func removeListeners() {
        userListener?.remove()
        quizzesListener?.remove()
    }
}
