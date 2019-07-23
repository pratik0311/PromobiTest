//
//  MyLocations+CoreDataProperties.swift
//  ProMobiTest

import Foundation
import CoreData

extension MyLocations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyLocations> {
        return NSFetchRequest<MyLocations>(entityName: "MyLocations")
    }

    @NSManaged public var location: String?

}
