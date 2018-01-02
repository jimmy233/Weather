//
//  LocationSelect.swift
//  Weather
//
//  Created by jimmy233 on 2018/1/1.
//  Copyright © 2018年 NJU. All rights reserved.
//

import Foundation
import UIKit
import AddressBook

enum LocationType
{
    case State
    case City
    case Area
}

protocol LocationSelectDelegate
{
    func locationSelected(location: String)
}

class LocationSelect: UITableViewController
{
    var locationType = LocationType.State
    var locations: NSArray!
    var locationPath = ""
    var locationName = ""
    
    var delegate:LocationSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    if locationType == .State {
        if let path = Bundle.main.path(forResource: "area", ofType: "plist")
        {
            locations = NSArray(contentsOfFile: path)
        }
    }
                                }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if locationType == .State {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationType == .State && section == 0 {
            return 1
        }
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "locationCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "locationCell")
        }
        
        switch locationType {
        case .State:
            if indexPath.section == 0
            {
                cell.textLabel?.text="区域选择"
            }
            else
            {cell.textLabel?.text = (self.locations[indexPath.row] as! NSDictionary)["state"] as? String
            }
        case .City:
            cell.textLabel?.text = (self.locations[indexPath.row] as! NSDictionary)["city"] as? String
       /* case .Area:
            cell.textLabel?.text = self.locations[indexPath.row] as? String*/
        default: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextLocationSelect = LocationSelect()
        nextLocationSelect.delegate = self.delegate
        let currentLocation = tableView.cellForRow(at: indexPath)?.textLabel?.text
        nextLocationSelect.locationPath = "\(locationPath) \(currentLocation!)"
        switch locationType {
        case .State:
            if indexPath.section == 0 {
                tableView.deselectRow(at: indexPath, animated: true)
                if !locationName.isEmpty {
                    self.delegate?.locationSelected(location: locationName)
                }
                return
            }
            nextLocationSelect.locations = (self.locations[indexPath.row] as! NSDictionary)["cities"] as! NSArray
            nextLocationSelect.locationType = .City
      /*  case .City:
            nextLocationSelect.locations = (self.locations[indexPath.row] as! NSDictionary)["areas"] as! NSArray*/
        default:
            nextLocationSelect.locations = []
            break
        }
        
        if (nextLocationSelect.locations.count > 0) {
            navigationController?.pushViewController(nextLocationSelect, animated: true)
        }
        else {
            let currentLocation = tableView.cellForRow(at: indexPath)?.textLabel?.text
            self.delegate?.locationSelected(location: "\(currentLocation!)")
        }
    }    
    
}
