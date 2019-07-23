//
//  Utility.swift
//  ProMobiTest

import UIKit
import CoreData

class Utility: NSObject {
    static var coreDataStack = CoreDataStack()
    
    private static var utility: Utility = {
        let utility = Utility()
        return utility
    }()
    
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    class func sharedInstance() -> Utility {
        return utility
    }
    
    class func mainContext() -> NSManagedObjectContext {
        return Utility.coreDataStack.persistentContainer.viewContext
    }
    
    class func getMD5From(location: String) -> String? {
        let md5Hex =  location.MD5().map { String(format: "%02hhx", $0) }.joined()
        return md5Hex
    }
}
