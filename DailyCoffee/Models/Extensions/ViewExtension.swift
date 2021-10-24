//
//  ViewExtension.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import SwiftUI

extension View {
    public func alert(isPresented: Binding<Bool>, _ alert: TextAlert) -> some View {
        AlertWrapper(isPresented: isPresented, alert: alert, content: self)
    }
}
