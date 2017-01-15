//
//  DiscoverVC.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverVC: UITableViewController {
    
    var places: [CKRecord] = []
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.loadDataFromICloud()
        
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let place = self.places[indexPath.row]
        if let name = place.object(forKey: "name") as? String {
            cell.textLabel?.text = name
        }
        
        //Lazy loading images
        cell.imageView?.image = #imageLiteral(resourceName: "p")
        let publicDB = CKContainer.default().publicCloudDatabase
        let fetchImageOperation = CKFetchRecordsOperation(recordIDs: [place.recordID])
        fetchImageOperation.desiredKeys = ["image"]
        fetchImageOperation.queuePriority = .veryHigh
        fetchImageOperation.perRecordCompletionBlock = { (record, recordId, error) in
            
            if error != nil {
                print(error)
                return
            }
            if let record = record {
                
                OperationQueue.main.addOperation({
                    if let image = record.object(forKey: "image") as? CKAsset {
                        let imageAsset = image
                        do {
                            try cell.imageView?.image = UIImage(data: Data(contentsOf: imageAsset.fileURL))
                        } catch {
                        }
                    }
                })
            }
        }
        
        publicDB.add(fetchImageOperation)
//        if let image = place.object(forKey: "image") as? CKAsset {
//            let imageAsset = image
//            do {
//                try cell.imageView?.image = UIImage(data: Data(contentsOf: imageAsset.fileURL))
//            } catch {
//                
//            }
//        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//ICloud
extension DiscoverVC {
    
    func loadDataFromICloud() {
        
        //API Operational
        self.places.removeAll()
        self.tableView.reloadData()
        ///////////////////////////
        
        let iCloudContainer = CKContainer.default()
        let publicDB = iCloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Place", predicate: predicate)
        
        //API Operational load data
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 25
        queryOperation.recordFetchedBlock = { (record: CKRecord?) in
            if let record = record {
                self.places.append(record)
            }
        }
        
        queryOperation.queryCompletionBlock = { cursor, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            OperationQueue.main.addOperation({
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
        publicDB.add(queryOperation)
        
        //cursor is for pagination, tells you where is the request stage at this moment is 25 first ones

    
        //API Convenience
        /*
        publicDB.perform(query, inZoneWith: nil) { [weak self] (results, error) in
            print("consult complete")
            
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if let results = results {
                self?.places = results
                OperationQueue.main.addOperation({ 
                    self?.tableView.reloadData()
                })
//                DispatchQueue.main.async { [weak self] in
//                    self?.tableView.reloadData()
//                }
            }
        }
       */
    }
}



