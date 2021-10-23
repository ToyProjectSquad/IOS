//
//  CoffeeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI
import CoreData

class CoffeeViewModel: ObservableObject {
    
    @Published var dailyCoffees: [Coffee] = []
    @Published var favoriteCoffees: [Coffee] = []
    
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
            dailyCoffees = try controller.viewContext.fetch(request)
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
                favoriteCoffees = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: Can't get coffees with favorite")
            }
            print("Successfully get coffees!\(favoriteCoffees.count)")
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
        let object = favoriteCoffees[index]
        controller.viewContext.delete(object)
        
        controller.save()
        getCoffeeWithFavorite()
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
