//
//  CafeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import SwiftUI
import CoreData

class CafeViewModel: ObservableObject {
    
    @Published
    var cafes: [Cafe] = []
    
    var user: User? = nil
    var sortDescriptor: String = "creationDate"
    
    private var controller = DataController.instance
    
    func configureUser(user: User) {
        self.user = user
    }
    
    func getCafe() {
        if let user = user {
            let request: NSFetchRequest<Cafe> = Cafe.fetchRequest()
            request.predicate = NSPredicate(format: "user == %@", user)
            request.sortDescriptors = [NSSortDescriptor(key: sortDescriptor, ascending: true)]
            
            do {
                cafes = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: Can't get cafes")
            }
        }
    }
    
    func addCafe(title: String, latitude: Double, longitutde: Double, image: UIImage, content: String?) {
        let newCafe = Cafe(context: controller.viewContext)
        newCafe.id = UUID().uuidString
        newCafe.title = title
        newCafe.latitude = latitude
        newCafe.longitude = longitutde
        newCafe.image = image.pngData()
        newCafe.content = content
        newCafe.creationDate = Date()
        
        controller.save()
        getCafe()
    }
    
    func deleteCafe(cafe: Cafe) {
        controller.viewContext.delete(cafe)
        controller.save()
        getCafe()
    }
    
    func deleteCafe(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let targetCafe = cafes[index]
        controller.viewContext.delete(targetCafe)
        controller.save()
        getCafe()
    }
    
}
