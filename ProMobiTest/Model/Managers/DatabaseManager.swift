//
//  DatabaseManager.swift
//  ProMobiTest

import UIKit

class DatabaseManager {

    class func saveMyLocations(_ location: String) {
        MyLocations.saveMyLocation(location)
    }
    
    class func getMyLocations() -> [MyLocations] {
        let myLocations = MyLocations.fetcheMyLocations(context: Utility.mainContext())
        return myLocations
    }
}
