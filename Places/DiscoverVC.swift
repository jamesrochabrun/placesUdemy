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
    var imageCache: NSCache = NSCache<CKRecordID, NSURL>()
    var lastCursor: CKQueryCursor?
    var hasLoadedInfo: Bool = false
    
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
        
        //pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.refreshControl?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.refreshControl?.addTarget(self, action: #selector(self.loadDataFromICloud), for: .valueChanged)
        
        
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
        
        //Cache images
        //get from cache if exists
        if let imageFileURL = self.imageCache.object(forKey: place.recordID) {
            do {
                print("image loaded from cache")
                try cell.imageView?.image = UIImage(data: Data(contentsOf: imageFileURL as URL))
            } catch {
            }
        } else { //create and save in cache
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
                            //save in cache
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: place.recordID)
                            do {
                                try cell.imageView?.image = UIImage(data: Data(contentsOf: imageAsset.fileURL))
                            } catch {
                            }
                        }
                    })
                }
            }
            publicDB.add(fetchImageOperation)
        }
        return cell
    }
}

//ICloud
extension DiscoverVC {
    
    func loadDataFromICloud() {
        
        //API Operational
//        self.places.removeAll()
//        self.tableView.reloadData()
        ///////////////////////////
        
        let iCloudContainer = CKContainer.default()
        let publicDB = iCloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Place", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //API Operational load data
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 1
        
        if self.lastCursor != nil {
            queryOperation.cursor = self.lastCursor
        } else if hasLoadedInfo {
            
            //we can add an alert here to say no more data available
            self.refreshControl?.endRefreshing()
            return
            //this avoids to get more data
//            self.places.removeAll()
//            self.tableView.reloadData()
        }
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
            
            //paging with the cursor
            self.hasLoadedInfo = true
            self.lastCursor = cursor
            
            OperationQueue.main.addOperation({
                self.refreshControl?.endRefreshing()
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



