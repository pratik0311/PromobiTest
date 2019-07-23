//
//  ViewController.swift
//  ProMobiTest

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var locationTableView: UITableView!
    
    var locationManager: CLLocationManager?
    var timer: Timer?
    private var  myDeviceViewModel: MyDeviceViewModel?

    // MARK: - ViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialiseMyLocationViewModel()
        self.setupLocationManager()
        self.setTimer()
        self.myDeviceViewModel?.fetchMyLocationFromDB()
        self.locationTableView.reloadData()
    }
    
    // MARK: - Custom Methods
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func initialiseMyLocationViewModel() {
        myDeviceViewModel = MyDeviceViewModel()
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
    }
    
    @objc func sayHello() {
        self.myDeviceViewModel?.fetchMyLocationFromDB()
        if !(self.myDeviceViewModel?.myLocations?.isEmpty ?? false) {
            locationTableView.reloadData()
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    fileprivate func cpuUsage() -> Double {
        var kr: kern_return_t
        var task_info_count: mach_msg_type_number_t
        
        task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))
        
        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
        if kr != KERN_SUCCESS {
            return -1
        }
        
        var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
        var thread_count: mach_msg_type_number_t = 0
        defer {
            if let thread_list = thread_list {
                vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
            }
        }
        
        kr = task_threads(mach_task_self_, &thread_list, &thread_count)
        
        if kr != KERN_SUCCESS {
            return -1
        }
        
        var tot_cpu: Double = 0
        
        if let thread_list = thread_list {
            
            for j in 0 ..< Int(thread_count) {
                var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                                 &thinfo, &thread_info_count)
                if kr != KERN_SUCCESS {
                    return -1
                }
                
                let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)
                
                if threadBasicInfo.flags != TH_FLAGS_IDLE {
                    tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            } // for each thread
        }
        
        return tot_cpu
    }
    
    fileprivate func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
        var result = thread_basic_info()
        
        result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
        result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
        result.cpu_usage = threadInfo[4]
        result.policy = threadInfo[5]
        result.run_state = threadInfo[6]
        result.flags = threadInfo[7]
        result.suspend_count = threadInfo[8]
        result.sleep_time = threadInfo[9]
        
        return result
    }
    
    private func prepareMyLocationsCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.myLocations) as? MyLocationsTableViewCell
        let myLocation = self.myDeviceViewModel?.myLocations?[indexPath.row]
        cell?.location = myLocation?.location ?? ""
        return cell ?? UITableViewCell()
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.fetchCityAndCountry(from: locations.last ?? CLLocation()) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            let cityCountry = city + ", " + country
            self.myDeviceViewModel?.location = cityCountry //Utility.getMD5From(location: cityCountry)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myDeviceViewModel?.myLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.prepareMyLocationsCell(tableView, indexPath)
    }
}
