
import FirebaseFirestore
import Foundation
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    let db = Firestore.firestore()
    var polls = [Poll]()

    @MainActor
    func listenToLivePolls() {
        db.collection("polls")
            .order(by: "updatedAt", descending: true)
            .limit(toLast: 10)
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                let docs = snapshot.documents
                let polls = docs.compactMap {
                    try? $0.data(as: Poll.self)
                }
                withAnimation {
                    self.polls = polls
                }
            }
    }
}
