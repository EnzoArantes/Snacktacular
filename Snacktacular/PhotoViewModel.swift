//
//  PhotoViewModel.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 4/7/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    
    static func saveImage(spot: Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {
            print("ERROR: SHould never have been called without a valid spot.id")
            return
        }
        
        let storage = Storage.storage().reference()
        let metaData = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString
        }
        metaData.contentType = "image/jpeg"
        let path = "\(id)/\(photo.id ?? "n/a")"
        
        do {
            let storageRef = storage.child(path)
            let returnedMetaData = try await storageRef.putDataAsync(data, metadata: metaData)
            print("SAVED \(returnedMetaData)")
            
            guard let url = try? await storageRef.downloadURL() else {
                print("ERROR: COuld not downloadURL")
                return
            }
            photo.imageURLSTring = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLSTring)")
            
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("ERROR: Could not update data in spots/\(id)/photos/\(photo.id ?? "n/a").")
            }
        } catch {
            print("ERROR Saving photo to Storage \(error.localizedDescription)")
        }
    }
}
