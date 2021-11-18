//
//  UIAlertControllerExtension.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import UIKit

extension UIAlertController {
    convenience init(alert: TextAlert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        addTextField {
            $0.placeholder = alert.placeholder
            $0.keyboardType = alert.keyboardType
        }
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil)
        })
        let textField = self.textFields?.first
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text)
        })
    }
}
