//
//  CoffeeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI
import CoreData

class CoffeeViewModel: ObservableObject {
    
    @Published var coffees: [Coffee] = []
//    @Published var dailyCoffees: [Coffee] = []
//    @Published var favoriteCoffees: [Coffee] = []
    
    private var controller = DataController.instance
    private var user: User? = nil
    private var histories: [History] = []
    
    func configureUser(user: User) {
        self.user = user
    }
    
    func getCoffeeWithHistory(date: Date = Date()) {
        getHistory(date: date)
        
        let request: NSFetchRequest<Coffee> = Coffee.fetchRequest()
        let predicate = NSPredicate(format: "consumedDate == %@", histories.first!)
        request.predicate = predicate
        request.sortDescriptors = []
        
        do {
            coffees = try controller.viewContext.fetch(request)
        } catch {
            fatalError("ERROR: Can't get coffees with history")
        }
    }
    
    func getCoffeeWithFavorite() {
        if let user = user {
            print("Get coffee with favorite list...")
            if user.favorite == nil {
                let  newFavorite = Favorite(context: controller.viewContext)
                newFavorite.user = user
                controller.save()
            }
            let request: NSFetchRequest<Coffee> = Coffee.fetchRequest()
            let predicate = NSPredicate(format: "favoriteList == %@", user.favorite!)
            request.predicate = predicate
            request.sortDescriptors = []
            
            do {
                coffees = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: Can't get coffees with favorite")
            }
            print("Successfully get coffees!\(coffees.count)")
        }
    }
    
    func addCoffeeToFavorite(title: String, image: UIImage, size: Double, caffeine: Double) {
        guard let user = user else { return }
        
        let newCoffee = Coffee(context: controller.viewContext)
        newCoffee.caffeine = caffeine
        newCoffee.title = title
        newCoffee.id = UUID().uuidString
        newCoffee.size = size
        newCoffee.image = image.pngData()
        newCoffee.creationDate = Date()
        newCoffee.favoriteList = user.favorite!
        
        controller.save()
        getCoffeeWithFavorite()
    }
    
    func deleteCoffeeInFavorite(indexSet: IndexSet) {
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
        getHistory(date: Date())
        let todayHistory = histories.first!
        let copiedObject: Coffee = Coffee(context: controller.viewContext)
        copiedObject.id = UUID().uuidString
        copiedObject.caffeine = coffee.caffeine
        copiedObject.title = coffee.title
        copiedObject.image = coffee.image
        copiedObject.size = coffee.size
        todayHistory.addToCoffees(copiedObject)
        
        controller.save()
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
        
        controller.save()
    }
    
    func deleteCoffeeFromDaily(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let object = coffees[index]
        controller.viewContext.delete(object)
        
        controller.save()
        getCoffeeWithHistory()
    }
    
    func deleteCoffeeFromDaily(coffee: Coffee) {
        controller.viewContext.delete(coffee)
        controller.save()
        getCoffeeWithHistory()
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
