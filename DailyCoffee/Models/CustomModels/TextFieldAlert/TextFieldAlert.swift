//
//  TextFieldAlert.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import SwiftUI

public struct TextAlert {
    var title: String
    var message: String?
    var placeholder: String = ""
    var accept: String = "OK"
    var cancel: String = "Cancel"
    var keyboardType: UIKeyboardType = .default
    var action: (String?) -> Void
}
