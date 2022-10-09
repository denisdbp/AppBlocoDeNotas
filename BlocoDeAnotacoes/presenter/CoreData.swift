//
//  CoreDataContext.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 04/10/22.
//

import Foundation
import UIKit
import CoreData

class CoreData {
    
    static let shared:CoreData = CoreData()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private init(){}
    
    public func coreDataContext()->NSManagedObjectContext{
        if let context = self.appDelegate?.persistentContainer.viewContext {
            return context
        }
        return NSManagedObjectContext.init()
        
    }
    
    public func entityName()->NSEntityDescription{
        if let entity = NSEntityDescription.entity(forEntityName: "Anotacoes", in: self.coreDataContext()) {
            return entity
        }
        return NSEntityDescription()
    }
    
    public func fetchRequest()->NSFetchRequest<NSFetchRequestResult>{
        return NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacoes")
    }
}
