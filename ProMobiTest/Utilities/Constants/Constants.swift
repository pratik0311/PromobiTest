//
//  Constants.swift
//  ProMobiTest

import UIKit

class Constants: NSObject {

    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    struct StoryboardIDs {
        static let viewController = "ViewController"
    }
    
    struct CellIdentifiers {
        static let myLocations = "MyLocationsTableViewCell"
    }
    
    struct CoreDataKeys {
        static let persistentContainerName = "ProMobiTest"
        static let context = "context"
        static let location = "location"
    }
    
    struct EntityNames {
        static let myLocations = "MyLocations"
    }
}
