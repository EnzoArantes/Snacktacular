//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 3/29/25.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
    
    static func saveSpot(spot: Spot) async -> String? {
        let db = Firestore.firestore()
        
        if let id = spot.id {
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data updated successfully")
                return id
            } catch {
                print("😡 Could not update data in 'spots' \(error.localizedDescription)")
                return id
            }
        }
        else {
            do {
                let docRef = try db.collection("spots").addDocument(from: spot)
                print("🐣 Data add successfully")
                return docRef.documentID
            } catch {
                print("😡 Could not create new spot in 'spots' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        guard let id = spot.id else {
            print("No spot.id")
            return
        }
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
            } catch {
                print("😡 ERROR: Could not delte document \(id). \(error.localizedDescription)")
            }
        }
    }
}
