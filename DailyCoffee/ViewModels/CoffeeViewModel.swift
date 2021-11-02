//
//  CoffeeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI
import CoreData

class CoffeeViewModel: ObservableObject {
    
    @Published
    var coffees: [Coffee] = []
    @Published
    var todayCaffeine: Double = 0
    
    private var controller = DataController.instance
    private var user: User? = nil
    private var histories: [History] = []
    
    func configureUser(user: User) {
        self.user = user
    }
    
    func getCoffeeWithHistory(date: Date = Date()) {
        getHistory(date: date)
        
        coffees = histories.first!.coffees?.allObjects as? [Coffee] ?? []
    }
    
    func getCoffeeWithFavorite() {
        if let user = user {
            if let favorite = user.favorite {
                coffees = favorite.coffees?.allObjects as? [Coffee] ?? []
            } else {
                let  newFavorite = Favorite(context: controller.viewContext)
                newFavorite.user = user
                controller.save()
            }
        }
    }
    
    func addCoffeeToFavorite(title: String, image: UIImage, size: Double, caffeine: Double) {
        guard let user = user else { return }
        guard let favorite = user.favorite else { return }
        
        let newCoffee = Coffee(context: controller.viewContext)
        newCoffee.caffeine = caffeine
        newCoffee.title = title
        newCoffee.id = UUID().uuidString
        newCoffee.size = size
        newCoffee.image = image.pngData()
        newCoffee.creationDate = Date()
        favorite.addToCoffees(newCoffee)
        
        controller.save()
        getCoffeeWithFavorite()
    }
    
    func deleteCoffeeFromFavorite(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let object = coffees[index]
        controller.viewContext.delete(object)
        
        controller.save()
        getCoffeeWithFavorite()
    }
    
    func deleteCoffeeInFavorite(coffee: Coffee) {
        controller.viewContext.delete(coffee)
        controller.save()
        getCoffeeWithFavorite()
    }
    
    func addCoffeeToDaily(coffee: Coffee) {
        addCoffeeToDaily(caffeine: coffee.caffeine, size: coffee.size, image: UIImage(data: coffee.image!)!, title: coffee.title ?? "")
    }
    
    func addCoffeeToDaily(caffeine: Double, size: Double, image: UIImage, title: String) {
        getHistory(date: Date())
        let todayHistory = histories.first!
        let newCoffee: Coffee = Coffee(context: controller.viewContext)
        newCoffee.id = UUID().uuidString
        newCoffee.caffeine = caffeine
        newCoffee.title = title
        newCoffee.image = image.pngData()
        newCoffee.size = size
        todayHistory.addToCoffees(newCoffee)
        todayCaffeine += caffeine
        
        controller.save()
    }
    
    func deleteCoffeeFromDaily(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let object = coffees[index]
        todayCaffeine -= object.caffeine
        controller.viewContext.delete(object)
        
        controller.save()
        getCoffeeWithHistory()
    }
    
    func deleteCoffeeFromDaily(coffee: Coffee) {
        todayCaffeine -= coffee.caffeine
        controller.viewContext.delete(coffee)
        controller.save()
        getCoffeeWithHistory()
    }
    
    func getTodayCaffeine() {
        getCoffeeWithHistory()
        for coffee in coffees {
            todayCaffeine += coffee.caffeine
        }
    }
    
}

extension CoffeeViewModel {
    
    private func getHistory(date: Date) {
        if let user = user {
            let request: NSFetchRequest<History> = History.fetchRequest()
            let userPredicate = NSPredicate(format: "user == %@", user)
            let datePredicate = NSPredicate(format: "date == %@", getDateStr(date: date))
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            do {
                histories = try controller.viewContext.fetch(request)
                if histories.count == 0 {
                    let newHistory = History(context: controller.viewContext)
                    newHistory.date = getDateStr(date: Date())
                    user.addToHistory(newHistory)
                    histories.append(newHistory)
                    controller.save()
                }
                assert(histories.count == 1)
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
