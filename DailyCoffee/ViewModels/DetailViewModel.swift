//
//  DetailViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/22.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published
    var isPresent: Bool = false
    @Published
    var isEditMode: Bool = false
    @Published
    var selectedItem: Coffee? = nil
    
    func setEditMode() {
        isPresent = true
        isEditMode = true
        selectedItem = nil
    }
    
    func setSelectMode(coffee: Coffee) {
        isPresent = true
        isEditMode = false
        selectedItem = coffee
    }
    
    func setDefualtMode() {
        isPresent = false
        isEditMode = false
        selectedItem = nil
    }
}
