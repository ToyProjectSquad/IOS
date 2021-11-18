//
//  HistoryViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/27.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    
    @Published
    var user: User? = nil
    
    public init() {}
    
    func configureUser(user: User?) {
        self.user = user
    }
    
}
