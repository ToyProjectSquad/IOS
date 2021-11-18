//
//  HistoryView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI
import SwiftUICharts

struct HistoryView: View {
    
    // MARK: - VARIABLES
    @EnvironmentObject
    var userVM: UserViewModel
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    @EnvironmentObject
    var chartVM: ChartViewModel
    
    @State
    private var mode: Int = 0
    @State
    private var durationOption: Int = 0
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(maxHeight: 42)
                titleView
                pageControlView
                    .padding([.leading, .trailing], 18)
                    .padding(.bottom, 4)
                contentView
                    .padding(.bottom, 30)
                commentView
                Spacer()
            }
        }
        .onAppear {
            chartVM.configureUser(user: userVM.user!)
        }
        .environmentObject(chartVM)
    }
}

// MARK: - COMPONENTS
extension HistoryView {
    
    private var titleView: some View {
        HStack {
            Text("통계 기록")
                .foregroundColor(Color("TextColor"))
                .font(.system(size: 34, weight: .bold))
                .padding(18)
            Spacer()
        }
    }
    
    private var pageControlView: some View {
        Picker("", selection: $mode) {
            Text("차트")
                .tag(0)
            Text("캘린더")
                .tag(1)
        }
        .pickerStyle(.segmented)
        .background(Color(hex: "#E8E8E8"))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
    }
    
    private var contentView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
            if mode == 0 { chartView }
            else { calenderView }
        }
        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
        .padding([.leading, .trailing], 18)
        .frame(height: 340)
        
    }
    
    private var commentView: some View {
        VStack(alignment: .leading) {
            Text("추가 정보")
                .foregroundColor(Color("TextColor"))
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white))
        .padding([.leading, .trailing], 18)
    }
    
    private var chartView: some View {
        VStack {
            HStack {
                Text(String(durationOption == 0 ? "주별" : "월별") + " 카페인")
                    .font(.system(size: 24))
                    .foregroundColor(Color("TextColor"))
                    .padding()
                Spacer()
                Menu {
                    Button {
                        durationOption = 0
                    } label: {
                        Text("주별")
                    }
                    
                    Button {
                        durationOption = 1
                    } label: {
                        Text("월별")
                    }

                } label: {
                    Image("Ellipsis")
                        .padding()
                }
            }
            if durationOption == 0 {
                barChart
            } else {
                lineChart
            }
            Spacer()
        }
        
    }
    
    private var calenderView: some View {
        Text("캘린더 뷰")
    }
    
    private var lineChart: some View {
        LineView(style: Styles.lineChartStyleOne)
    }
    
    private var barChart: some View {
        BarChartView()
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
