//
//  ListView.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 3/29/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot] //loads all "spots" documents into the array variable named spots
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetialView(spot: spot)
                } label: {
                    Text(spot.name)
                        .font(.title2)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        SpotViewModel.deleteSpot(spot: spot)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Snack Spots:")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log Out Successful!")
                            dismiss()
                        } catch {
                            print("😡ERROR: Could not sign out")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetialView(spot: Spot())
                }
            }
        }
    }
}

#Preview {
    ListView()
}
