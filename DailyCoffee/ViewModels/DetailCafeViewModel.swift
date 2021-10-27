//
//  DetailCafeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/26.
//

import SwiftUI

class DetailCafeViewModel: ObservableObject {
    
    @Published
    var isEditMode: Bool = false
    @Published
    var grade: Int = 0
    @Published
    var title: String = ""
    @Published
    var image: UIImage = UIImage()
    @Published
    var content: String = ""
    
    func configure(selectedCafe: Cafe?) {
        if let selectedCafe = selectedCafe {
            grade = Int(selectedCafe.grade)
            title = selectedCafe.title ?? ""
            image = UIImage(data: selectedCafe.image!) ?? UIImage(named: "Placeholder")!
            content = selectedCafe.content ?? ""
        }
    }
    
    func cancel(selectedCafe: Cafe?) {
        configure(selectedCafe: selectedCafe)
        isEditMode = false
    }
    
    func setEditMode() {
        self.isEditMode = true
    }
    
}
