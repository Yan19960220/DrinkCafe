//
//  CafeTableViewController.swift
//  FoodTracker
//
//  Created by 张岩 on 2020/8/13.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class CafeTableViewController: UITableViewController {
        
    //MARK: Properties
    var cafes = [Cafe]()
    
    //MARK: Action
    @IBAction func unwindToCafeList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? CafeViewController, let cafe = sourceViewController.cafe {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                cafes[selectedIndexPath.row] = cafe
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let newIndexPath = IndexPath(row: cafes.count, section: 0)
                
                cafes.append(cafe)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveCafes()
        }
    }
    
    //MARK: Private Methods
    private func saveCafes(){
        let fullPath = Cafe.ArchiveURL
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: cafes, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("cafes saved successfully", log: OSLog.default, type: .default)
        }catch{
            os_log("cafes saved failed", log: OSLog.default, type: .error)
        }
    }
    
    private func loadCafes() -> [Cafe]? {
        let fullPath = Cafe.ArchiveURL
        if let NsData = NSData(contentsOf: fullPath){
            do {
                let data = Data(referencing: NsData)
                if let loadCafes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Cafe>{
                    return loadCafes
                }
            }catch{
                os_log("cafes load failed", log: OSLog.default, type: .error)
                return nil
            }
        }
        return nil
    }
    
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "Cafe A")
        let photo2 = UIImage(named: "Jozi Cafe")
        let photo3 = UIImage(named: "Little Cafe")
        
        guard let cafe1 = Cafe(name: "Cafe A", photo: photo1, rating: 3, address: "Avenue Jean Jaures 140") else {
            fatalError("Unable to instantiate cafe1")
        }
        
        guard let cafe2 = Cafe(name: "Jozi Cafe", photo: photo2, rating: 5, address: "Avenue Jean Jaures 140") else {
            fatalError("Unable to instantiate cafe1")
        }
        
        guard let cafe3 = Cafe(name: "Little Cafe", photo: photo3, rating: 4, address: "Avenue Jean Jaures 140") else {
            fatalError("Unable to instantiate cafe1")
        }
        
        cafes += [cafe1, cafe2, cafe3]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let MyCafes = loadCafes(){
            cafes += MyCafes
        }else {
            loadSampleMeals()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cafes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CafeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CafeTableViewCell else {
            fatalError("the instance type is not CafeTableViewCesll")
        }
        let cafe = cafes[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = cafe.name
        cell.photoImageView.image = cafe.photo
        cell.ratingControl.rating = cafe.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cafes.remove(at: indexPath.row)
            saveCafes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding an item", log: OSLog.default, type: .default)
        case "ShowDetail":
            guard let cafeDetailViewController = segue.destination as? CafeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? CafeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCafe = cafes[indexPath.row]
            cafeDetailViewController.cafe = selectedCafe
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
}
