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
    
    private var controller = DataController.instance
    private var user: User? = nil
    private var histories: [History] = []
    
    init() {
        
    }
    
    func configureUser(user: User) {
        self.user = user
    }
    
    func getWeekCoffeeWithHistory(date: Date) {
        getWeekHistory(date: date)
        
        var coffeeInHistory: [Coffee] = []
        
        for history in histories {
            coffeeInHistory.append(contentsOf: history.coffees?.allObjects as? [Coffee] ?? [])
        }
        coffees.append(contentsOf: coffeeInHistory)
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
    
    private func getDateStr(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
}
