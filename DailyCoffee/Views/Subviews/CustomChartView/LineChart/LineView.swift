//
//  LineView.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/30.
//

import SwiftUI
import SwiftUICharts

public struct LineView: View {
    
    @ObservedObject
    var data: ChartData
    
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var valueSpecifier: String
    
    @Environment(\.colorScheme)
    var colorScheme: ColorScheme
    
    @State
    private var dragLocation:CGPoint = .zero
    @State
    private var indicatorLocation:CGPoint = .zero
    @State
    private var closestPoint: CGPoint = .zero
    @State
    private var opacity:Double = 0
    @State
    private var currentDataNumber: Double = 0
    @State
    private var hideHorizontalLines: Bool = false
    
    public init(data: ChartData,
                style: ChartStyle = Styles.lineChartStyleOne,
                valueSpecifier: String? = "%.1f") {
        self.data = data
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
//                VStack {
//                    ForEach(getDataPoint(), id: \.self) { data in
//                        Text(data)
//                            .frame(maxHeight: .infinity)
//                    }
//                }
                VStack(alignment: .leading, spacing: 8) {
                    ZStack{
                        GeometryReader{ reader in
                            Line(data: self.data,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width, height: reader.frame(in: .local).height + 25)),
                                 touchLocation: self.$indicatorLocation,
                                 showIndicator: self.$hideHorizontalLines,
                                 minDataValue: .constant(nil),
                                 maxDataValue: .constant(nil),
                                 currentValue: $currentDataNumber,
                                 showBackground: false,
                                 gradient: self.style.gradientColor
                            )
                        }
                        .frame(width: geometry.frame(in: .local).size.width, height: geometry.frame(in: .local).size.height)
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: geometry.frame(in: .local).size.height)
                    .gesture(DragGesture()
                                .onChanged({ value in
                        self.dragLocation = value.location
                        self.indicatorLocation = CGPoint(x: max(value.location.x, 0), y: 32)
                        self.opacity = 1
                        self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width, height: geometry.frame(in: .local).size.height)
                        self.hideHorizontalLines = true
                    })
                                .onEnded({ value in
                        self.opacity = 0
                        self.hideHorizontalLines = false
                    })
                    )
//                    HStack {
//                        ForEach(data.points.map({ data in
//                            return data.0
//                        }), id: \.self) { date in
//                            Text(date)
//                                .frame(maxWidth: .infinity)
//                                .font(.system(size: 15, weight: .bold))
//                                .foregroundColor(Color("TextColor"))
//                        }
//                    }
                }
            }
        }
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count - 1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        let index:Int = Int(floor((toPoint.x - 15) / stepWidth))
        
        if index >= 0 && index < points.count {
            self.currentDataNumber = points[index]
            return CGPoint(x: CGFloat(index) * stepWidth, y: CGFloat(points[index]) * stepHeight)
        }
        return .zero
    }
    
    func getDataPoint() -> [String] {
        let dataPoints = self.data.points.map { data in
            return data.1
        }
        let maxData = String("\(dataPoints.max() ?? 0)")
        let minData = String("\(dataPoints.min() ?? 0)")
        let avgData = String("\(((dataPoints.max() ?? 0) + (dataPoints.min() ?? 0)) / 2)")
        
        return [maxData, avgData, minData]
    }
}

struct LineView_Previews: PreviewProvider {
    
    static var previews: some View {
        LineView(data: TestData.monthlyFirst, style: Styles.lineChartStyleOne)
            .frame(height: 140)
//        Group {
//            LineView(data: [8,23,54,32,12,37,7,23,43], style: Styles.lineChartStyleOne)
//
//            LineView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188], style: Styles.lineChartStyleOne)
//
//        }
    }
}
