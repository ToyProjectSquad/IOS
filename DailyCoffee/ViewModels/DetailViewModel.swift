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
    var mode: Int = 0
    @Published
    var selectedItem: Coffee? = nil
    
    func setCreateMode() {
        isPresent = true
        mode = 1
        selectedItem = nil
    }
    
    func setEditMode(coffee: Coffee) {
        isPresent = true
        mode = 2
        selectedItem = coffee
    }
    
    func setSelectMode(coffee: Coffee) {
        isPresent = true
        mode = 0
        selectedItem = coffee
    }
    
    func setDefualtMode() {
        isPresent = false
        mode = 0
        selectedItem = nil
    }
    
}
