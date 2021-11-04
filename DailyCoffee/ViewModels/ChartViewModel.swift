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
    
    func configureUser(user: User) {
        self.user = user
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
    
    private func getFirstDayofThisYear(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        var dateStr = year + "-01-01"
    }
    
    private func getDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        return dateFormatter.string(from: date)
    }
    
}
