//
//  ChartViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/11/02.
//

import SwiftUI
import CoreData

class ChartViewModel: ObservableObject {
    
    @Published
    var coffees: [Coffee] = []
    @Published
    var weeklyCaffeine: [Double] = []
    @Published
    var monthlyCaffeine: [Double] = []
    
    private var controller = DataController.instance
    private var user: User? = nil
    private var histories: [History] = []
    
    
    public let month: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    public let monthDays: [Int] = [
        31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    ]
    
    func configureUser(user: User) {
        self.user = user
    }
    
    func getCaffeine() {
        getWeeklyCoffee()
        getMonthlyCoffee()
    }
    
    func getWeeklyCoffee(date: Date = Date()) {
        getWeekHistory(date: date)
        
        var data: [Double] = []
        var caffeine: Double = 0
        
        for history in histories {
            caffeine = 0
            for coffee in history.coffees?.allObjects as? [Coffee] ?? [] {
                caffeine += coffee.caffeine
            }
            data.append(caffeine)
        }
        while data.count < 7 {
            data.append(0)
        }
        weeklyCaffeine = data
    }
    
    func getMonthlyCoffee(date: Date = Date()) {
        var data: [Double] = []
        for m in 1...12 {
            data.append(getMonthHistory(month: m) / Double(monthDays[m - 1]))
        }
        monthlyCaffeine = data
        print(data)
    }
    
}

extension ChartViewModel {
    
    private func getWeekHistory(date: Date) {
        if let user = user {
            let request: NSFetchRequest<History> = History.fetchRequest()
            let userPredicate = NSPredicate(format: "user == %@", user)
            let datePredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", getDateStr(date: Date.today().previous(.monday)), getDateStr(date: date))
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                histories = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: Can't get history")
            }
        }
    }
    
    private func getMonthHistory(date: Date) {
        if let user = user {
            let request: NSFetchRequest<History> = History.fetchRequest()
            let userPredicate = NSPredicate(format: "user == %@", user)
            let datePredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", getDateStr(date: Date.today().previous(.monday)), getDateStr(date: date))
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                histories = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: Can't get history")
            }
        }
    }
    
    private func getMonthHistory(month: Int) -> Double {
        var monthHistory: [History] = []
        var monthCaffeine: Double = 0
        
        if let user = user {
            let request: NSFetchRequest<History> = History.fetchRequest()
            let userPredicate = NSPredicate(format: "user == %@", user)
            let datePredicate = NSPredicate(format: "(date >= %@) AND (date < %@)", getDateStr(month: month), getDateStr(month: month + 1))
            print(getDateStr(month: month))
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                monthHistory = try controller.viewContext.fetch(request)
                for history in monthHistory {
                    for coffee in history.coffees?.allObjects as? [Coffee] ?? [] {
                        monthCaffeine += coffee.caffeine
                    }
                }
            } catch {
                fatalError("ERROR: Can't get history")
            }
        }
        return monthCaffeine
    }
    
    private func getDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    private func getDateStr(month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: Date())
        return year + "-\(String(format: "%02d", month))-01"
    }
    
}
