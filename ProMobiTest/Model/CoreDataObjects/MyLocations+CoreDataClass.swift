//
//  MyLocations+CoreDataClass.swift
//  ProMobiTest

import Foundation
import CoreData

@objc(MyLocations)
public class MyLocations: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: String(describing: MyLocations.self), in: managedObjectContext) else {
                fatalError("Failed to decode vehicle!")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        
        // Decode
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decode(String.self, forKey: .location)
    }
}

extension MyLocations: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location, forKey: .location)
    }
    
    class func saveMyLocation(_ location: String) {
        let context = Utility.mainContext()
        let entity = NSEntityDescription.entity(forEntityName: Constants.EntityNames.myLocations, in: context)!
        let myLocation = NSManagedObject(entity: entity, insertInto: context)
        myLocation.setValue(location, forKey: Constants.CoreDataKeys.location)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func fetcheMyLocations(context: NSManagedObjectContext) -> [MyLocations] {
        let fetchRequest: NSFetchRequest = MyLocations.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        var result: [MyLocations] = []
        do {
            result = try context.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
}
