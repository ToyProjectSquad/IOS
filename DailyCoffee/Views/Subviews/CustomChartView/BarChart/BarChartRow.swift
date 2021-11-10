//
//  BarChartRow.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/31.
//

import SwiftUI

public struct BarChartRow : View {
    
    @Binding
    var selection: Int
    
    @State
    var didTapped: Bool = false
    
    var data: [Double]
    var accentColor: Color
    var gradient: GradientColor?
    var maxValue: Double {
        guard let max = data.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }
    
    private let labelData: [String] = [
        "M", "T", "W", "T", "F", "S", "S"
    ]
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.size.width - 25 * 7) / 6) {
                ForEach(0..<self.data.count, id: \.self) { i in
                    BarChartCell(didTapped: .constant(selection == i),
                                 label: labelData[i],
                                 height:  self.normalizedValue(index: i) * geometry.size.height * 0.8,
                                 accentColor: self.accentColor,
                                 gradient: self.gradient)
                        .onTapGesture {
                            if selection != i {
                                selection = i
                            } else {
                                selection = -1
                            }
                        }
                }
            }
        }
        .onTapGesture {
            selection = -1
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        return Double(self.data[index]) / Double(self.maxValue) * 0.9
    }
}
