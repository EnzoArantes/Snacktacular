//
//  Spot.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 3/29/25.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    
}
