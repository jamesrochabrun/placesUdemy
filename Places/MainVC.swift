//
//  TableViewController.swift
//  places
//
//  Created by James Rochabrun on 11/30/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class MainVC: UITableViewController {
    
    var places: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My places"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.hidesBarsOnSwipe = true
        
        var place = Place(name: "usa", type: "America", location: "15 el pulgar", image:#imageLiteral(resourceName: "sasha"), telephone:"5555", web: "http://www.deemelo.com")
        places.append(place)
        
        place = Place(name: "cuba", type: "America", location: "18 el pulgar", image: #imageLiteral(resourceName: "sasha"), telephone:"5558", web: "http://www.deemelo.com")
        places.append(place)
    
        place = Place(name: "india", type: "Africa", location: "100 el pulgar", image: #imageLiteral(resourceName: "sasha"), telephone:"5559", web: "http://www.deemelo.com")
        places.append(place)
        
        place = Place(name: "Peru", type: "America", location: "200 el pulgar", image: #imageLiteral(resourceName: "sasha"), telephone:"5550", web: "http://www.deemelo.com")
        places.append(place)
        
        place = Place(name: "Chile", type: "America", location: "450 rockridge", image: #imageLiteral(resourceName: "sasha"), telephone:"5557", web: "http://www.deemelo.com")
        places.append(place)
        
        place = Place(name: "China", type: "Asia", location: "300 bronx", image: #imageLiteral(resourceName: "sasha"), telephone:"55557654", web: "http://www.deemelo.com")
        places.append(place)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
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
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceCell
        
        // Configure the cell...
        let place = places[indexPath.row]
        cell.titleLabel.text = place.name
        cell.avatarView.image = place.image
        cell.subTitleLabel.text = place.location
        cell.thirdLabel.text = place.type
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            self.places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let shareAction = UITableViewRowAction(style: .default, title: "share") { (action, indexPath) in
            
            let place = self.places[indexPath.row]
            let sharedefaultText = "i like the place of \(place.name)"
            
            let activityController = UIActivityViewController(activityItems: [sharedefaultText,place.image],applicationActivities: nil)
            
            DispatchQueue.main.async { [weak self] in
                self?.present(activityController, animated: true, completion: nil)
            }
        }
        shareAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            
            self.places.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .fade)
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
            if let IndexPath = self.tableView.indexPathForSelectedRow {
                let selectedPlace = self.places[IndexPath.row]
                let destinationVC = segue.destination as! DetailVC
                destinationVC.place = selectedPlace
            }
        }
        
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) {
        
        if segue.identifier == "unwindToMainVC" {
            if let addPlaceVC = segue.source as? AddPlaceVC {
                if let newPlace =  addPlaceVC.place {
                self.places.append(newPlace)
                self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    
    
    
    

    
}
