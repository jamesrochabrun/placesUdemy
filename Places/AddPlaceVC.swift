//
//  AddPlaceVC.swift
//  Places
//
//  Created by James Rochabrun on 1/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class AddPlaceVC: UITableViewController {

    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AddPlaceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagepicker = UIImagePickerController()
                imagepicker.allowsEditing = false
                imagepicker.sourceType = .photoLibrary
                imagepicker.delegate = self
                self.present(imagepicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.imageview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageview.contentMode = .scaleAspectFill
        self.imageview.clipsToBounds = true
        let leadingConstraint = NSLayoutConstraint(item: self.imageview, attribute: .leading, relatedBy: .equal, toItem: self.imageview.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        let trailingConstraint = NSLayoutConstraint(item: self.imageview, attribute: .trailing, relatedBy: .equal, toItem: self.imageview.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        let topConstraint = NSLayoutConstraint(item: self.imageview, attribute: .top, relatedBy: .equal, toItem: self.imageview.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: self.imageview, attribute: .bottom, relatedBy: .equal, toItem: self.imageview.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
