//
//  CafeViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import SwiftUI
import GoogleMaps
import CoreData

class CafeViewModel: ObservableObject {
    
    @Published
    var cafes: [Cafe] = []
    @Published
    var markers: [GMSMarker] = []
    @Published
    var selectedMarker: GMSMarker? = nil
    @Published
    var selectedCafe: Cafe? = nil
    
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
                markers = cafes.map {
                    let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
                    marker.title = $0.title
                    return marker
                }
                print(markers.count)
            } catch {
                fatalError("ERROR: Can't get cafes")
            }
        }
    }
    
    func addCafe(title: String, latitude: Double, longitutde: Double, grade: Int, image: UIImage, content: String?) {
        let newCafe = Cafe(context: controller.viewContext)
        newCafe.id = UUID().uuidString
        newCafe.title = title
        newCafe.latitude = latitude
        newCafe.longitude = longitutde
        newCafe.image = image.pngData()
        newCafe.content = content
        newCafe.creationDate = Date()
        newCafe.user = user
        newCafe.grade = Int16(grade)
        
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
    
    func editCafe(title: String? = nil,
                  latitude: Double? = nil,
                  longitutde: Double? = nil,
                  grade: Int? = nil,
                  image: UIImage? = nil,
                  content: String? = nil) {
        if let title = title {
            selectedCafe?.title = title
        }
        if let content = content {
            selectedCafe?.content = content
        }
        if let image = image {
            selectedCafe?.image = image.pngData()
        }
        if let grade = grade {
            selectedCafe?.grade = Int16(grade)
        }
        if let latitude = latitude {
            selectedCafe?.latitude = latitude
        }
        if let longitutde = longitutde {
            selectedCafe?.longitude = longitutde
        }
        
        controller.save()
    }
    
    func findCafeWithMarker() {
        if let selectedMarker = selectedMarker {
            selectedCafe = self.cafes.filter {
                $0.latitude == selectedMarker.position.latitude &&
                $0.longitude == selectedMarker.position.longitude
            }.first
        }
    }
    
}
