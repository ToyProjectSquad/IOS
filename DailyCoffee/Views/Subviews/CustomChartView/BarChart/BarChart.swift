//
//  BarChart.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/31.
//

import SwiftUI

public struct BarChartView : View {
    
    @Environment(\.colorScheme)
    var colorScheme: ColorScheme
    
    @State
    var selection: Int = -1
    
    private var data: ChartData
    
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    
    public init(data:ChartData, style: ChartStyle = Styles.barChartStyleOrangeLight) {
        self.data = data
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.barChartStyleOrangeDark
    }
    
    public var body: some View {
        BarChartRow(selection: $selection,
                    data: data.points.map{ $0.1 },
                    accentColor: self.colorScheme == .dark ? self.darkModeStyle.accentColor : self.style.accentColor,
                    gradient: self.colorScheme == .dark ? self.darkModeStyle.gradientColor : self.style.gradientColor)
            .padding()
    }
}
