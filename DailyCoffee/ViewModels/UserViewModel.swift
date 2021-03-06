//
//  UserViewModel.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI
import CoreData

final class UserViewModel: ObservableObject {
    @Published
    var user: User? = nil
    
    var id: String? = nil
    
    private var fetchResult: [User] = []
    
    private var controller = DataController.instance
    
    func configureID(id: String) {
        self.id = id
    }
    
    func configureUser() {
        fetchUser()
        assert(fetchResult.count == 1)
        user = fetchResult.first
    }
    
    func addUser(id: String, displayName: String, maxFull: Double, photo: UIImage) {
        self.id = id
        let newUser = User(context: controller.viewContext)
        newUser.id = id
        newUser.displayName = displayName
        newUser.maxFull = maxFull
        newUser.profileImage = photo.pngData()
        newUser.comment = "안녕하세요.\(displayName)입니다."
        
        let favorite = Favorite(context: controller.viewContext)
        favorite.user = newUser
        
        controller.save()
        configureUser()
    }
    
    func editUser(displayName: String, comment:String, photo:UIImage){
        if let user = user{
            user.displayName = displayName
            user.comment = comment
            user.profileImage = photo.pngData()
        }
        
        controller.save()
        configureUser()
    }
    
    private func fetchUser() {
        if let id = id {
            let request: NSFetchRequest<User> = User.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id)
            request.predicate = predicate
            request.sortDescriptors = []
            
            do {
                fetchResult = try controller.viewContext.fetch(request)
            } catch {
                fatalError("ERROR: User can't be configured")
            }
        }
    }
}
