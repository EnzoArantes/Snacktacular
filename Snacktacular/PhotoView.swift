//
//  PhotoView.swift
//  Snacktacular
//
//  Created by Enzo Arantes on 3/31/25.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot // passed in from SpotDetailView
    @State private var photo = Photo()
    @State private var data = Data()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true //TODO: Switch to true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            
            Spacer()
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("description", text: $photo.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("by: \(photo.reviwer), on \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    // turn selectedPhoto into usable image view
                    Task {
                        do {
                            if let image = try await
                                selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            
                            guard let transferredDate = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("ERROR: COULD NOT CONVERT DATA FROM SELECTED PHOTO")
                                return
                            }
                            data = transferredDate
                        } catch {
                            print("😡 ERROR: Could not create image from selected photo. \(error.localizedDescription)")
                        }
                    }
                    
                }
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot())
}
