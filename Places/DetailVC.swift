//
//  DetailVC.swift
//  places
//
//  Created by James Rochabrun on 12/1/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var placeImageView: UIImageView!
    var place: Place!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        DispatchQueue.main.async { [weak self] in
            self?.placeImageView.image = self?.place.image
            self?.title = self?.place.name
        }
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        self.ratingbutton.setImage(UIImage(named: self.place.rating), for:.normal)
        
//        self.tableView.estimatedRowHeight = 44.0
//        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
        if let reviewVC = segue.source as? ReviewVC {
            
            if let rating = reviewVC.ratingSelected {
                print(rating)
                self.place.rating = rating
                self.ratingbutton.setImage(UIImage(named: self.place.rating), for:.normal)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! PlaceDetailCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Name:"
            cell.valueLabel.text = self.place.name
        case 1:
            cell.keyLabel.text = "Type:"
            cell.valueLabel.text = self.place.type
        case 2:
            cell.keyLabel.text = "Location:"
            cell.valueLabel.text = self.place.location
        case 3:
            cell.keyLabel.text  = "phone:"
            cell.valueLabel.text = self.place.telephone
        case 4:
            cell.keyLabel.text =  "Web:"
            cell.valueLabel.text = self.place.web
        default:
            break
        }
        return cell
    }
    
}

extension DetailVC: UITableViewDelegate {
    
    
    
}








