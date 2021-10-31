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
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.size.width - 25 * 7) / 6) {
                ForEach(0..<self.data.count, id: \.self) { i in
                    BarChartCell(didTapped: .constant(selection == i),
                                 accentColor: self.accentColor,
                                 gradient: self.gradient)
                        .frame(width: 25, height: self.normalizedValue(index: i) * geometry.size.height, alignment: .center)
                        .scaleEffect(selection == i ? CGSize(width: 1.3, height: 0.9) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
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
