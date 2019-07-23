//
//  MyDeviceViewModel.swift
//  ProMobiTest

import UIKit

class MyDeviceViewModel: NSObject {

    var location: String? {
        didSet {
            self.saveMyLocationInDB(location)
        }
    }
    
    var myLocations: [MyLocations]?
    
    func saveMyLocationInDB(_ location: String?) {
        DatabaseManager.saveMyLocations(location ?? "")
    }
    
    func fetchMyLocationFromDB() {
        self.myLocations = DatabaseManager.getMyLocations()
    }
}
