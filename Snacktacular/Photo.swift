//
//  Photo.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 4/7/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLSTring = ""
    var description = ""
    var reviwer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    init(id: String? = nil, imageURLSTring: String = "", description: String = "", reviwer: String = (Auth.auth().currentUser?.email ?? ""), postedOn: Date = Date()) {
        self.id = id
        self.imageURLSTring = imageURLSTring
        self.description = description
        self.reviwer = reviwer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(
            id: "1",
            imageURLSTring: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza-3007395.jpg/500px-Pizza-3007395.jpg",
            description: "Yummy pizza",
            reviwer: "little@ceasars.com",
            postedOn: Date()
        )
        return newPhoto
    }
}
