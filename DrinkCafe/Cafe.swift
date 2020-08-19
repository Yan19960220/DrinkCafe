//
//  Cafe.swift
//  FoodTracker
//
//  Created by 张岩 on 2020/8/13.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class Cafe: NSObject, NSCoding {
    
    //MARK: properties
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let address = "address"
    }
    var name: String
    var photo: UIImage?
    var rating: Int
    var address: String
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int, address: String) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 || address.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.address = address
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cafes")
    
    //MARK: NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
        coder.encode(address, forKey: PropertyKey.address)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for the Cafe object!", log: OSLog.default, type: .default)
            return nil
        }
        
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        guard let address = coder.decodeObject(forKey: PropertyKey.address) as? String else {
            os_log("Unable to decode the address for the Cafe object!", log: OSLog.default, type: .default)
            return nil
        }
        
        self.init(name: name, photo: photo, rating: rating, address: address)
    }
}
