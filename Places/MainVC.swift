//
//  TableViewController.swift
//  places
//
//  Created by James Rochabrun on 11/30/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UITableViewController {
    
    var places: [Place] = []
    var fetchResultsController : NSFetchedResultsController<Place>!
    var searchController: UISearchController!
    var searchResults: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My places"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.hidesBarsOnSwipe = true
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.placeholder = "Search places"
        self.searchController.searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.searchController.searchBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.searchController.dimsBackgroundDuringPresentation = false
        //setting the delegate
        self.searchController.searchResultsUpdater = self
        
        
        
        //step 2
        //initialize the fetchresultcontroller 
        let fetchRequest: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //step 3 changes step 1 adding the delegate
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            
            let context = container.viewContext
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                self.places = fetchResultsController.fetchedObjects!
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        //step 1
        //fetch data from coredata
//        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
//            
//            let context = container.viewContext
//            //opcion A
//            let request: NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
//            //opcion B if we create a subclass
//            // let request: NSFetchRequest<Place> = Place.fetchRequest() as! NSFetchRequest<Place>
//            
//            do {
//                self.places = try context.fetch(request)
//
//            } catch {
//                print("Error: \(error)")
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "TutorialPageController") as? TutorialPageVC {
            self.present(pageVC, animated: true , completion: nil)
        }
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
        
        if self.searchController.isActive {
            return self.searchResults.count
        } else {
            return places.count
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceCell
        
        // Configure the cell...
        let place: Place!
        
        if self.searchController.isActive {
            place = self.searchResults[indexPath.row]
        } else {
            place = self.places[indexPath.row]
        }
        
        cell.titleLabel.text = place.name
        cell.avatarView.image = UIImage(data: place.image as! Data)
        cell.subTitleLabel.text = place.type
        cell.thirdLabel.text = place.location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            self.places.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let shareAction = UITableViewRowAction(style: .default, title: "share") { (action, indexPath) in
            
            let place: Place!
            
            if self.searchController.isActive {
                place = self.searchResults[indexPath.row]
            } else {
                place = self.places[indexPath.row]
            }
            
            let sharedefaultText = "i like the place of \(place.name)"
            
            let activityController = UIActivityViewController(activityItems: [sharedefaultText,UIImage(data:place.image as! Data)!],applicationActivities: nil)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(activityController, animated: true, completion: nil)
            }
        }
        shareAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            
            //delete coredata
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                
                let context = container.viewContext
                let placeToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(placeToDelete)
                
                do {
                    try context.save()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        return [shareAction, deleteAction]
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetail" {
            
            //optional binding
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let place: Place!
                if self.searchController.isActive {
                    place = self.searchResults[indexPath.row]
                } else {
                    place = self.places[indexPath.row]
                }
                
                let destinationVC = segue.destination as! DetailVC
                destinationVC.place = place
            }
        }
        
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToMainVC" {
            if let addPlaceVC = segue.source as? AddPlaceVC {
                if let newPlace =  addPlaceVC.place {
                    self.places.append(newPlace)
                }
            }
        }
    }
    
    func filterContentFor(textToSearch: String) {
        
        self.searchResults = self.places.filter({ (place) -> Bool in

            let nameToFind = place.name.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (nameToFind != nil) || (typeToFind != nil) || (locationToFind != nil)
        })
    }
}


//step 4
extension MainVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let  newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath , let newIndexPath = newIndexPath {
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
        
        self.places = controller.fetchedObjects as! [Place]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension MainVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterContentFor(textToSearch: searchText)
            self.tableView.reloadData()
        }
    }
    
}








