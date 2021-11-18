//
//  ImagePickerModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - VARIABLES
    // Binding
    @Binding
    var selectedImage: UIImage
    
    // Environment
    @Environment(\.presentationMode)
    private var presentationMode
    
    // Public
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // MARK: - MAKE UI VIEW CONTROLLER
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    // MARK: - UPDATE UI VIEW CONTROLLER
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    // MARK: - SET DELEGATE
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
         
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
         
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
