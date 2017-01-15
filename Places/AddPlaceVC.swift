//
//  AddPlaceVC.swift
//  Places
//
//  Created by James Rochabrun on 1/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddPlaceVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldType: UITextField!
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var textfieldWeb: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    var rating: String?
    let defaultColor = #colorLiteral(red: 0.1098039216, green: 0.6392156863, blue: 0.7843137255, alpha: 1)
    let selectedColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textfieldName.delegate = self
        self.textfieldType.delegate = self
        self.textfieldWeb.delegate = self
        self.textfieldPhone.delegate = self
        self.textfieldAddress.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let name = self.textfieldName.text,
            let type = self.textfieldType.text,
            let direction = self.textfieldAddress.text,
            let telephone = self.textfieldPhone.text,
            let website = self.textfieldWeb.text,
            let image = self.imageview.image,
            let rating = self.rating {
            
            //save in coredata
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                
                let context = container.viewContext
                
                self.place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place
                self.place?.name = name
                self.place?.type = type
                self.place?.location = direction
                self.place?.phone = telephone
                self.place?.web = website
                self.place?.rating = rating
                self.place?.image = UIImagePNGRepresentation(image) as NSData?

                do {
                    try context.save()
                } catch {
                    print("error to save place in core data")
                }
            }
                        
            self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
            
        } else {
            
            let alertController = UIAlertController(title: "missing data", message: "review it", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //save in icloud
    func savePlaceToIcloud(place: Place!) {
        
        let record = CKRecord(recordType: "Place")
        record.setValue(place.name, forKey: "name")
        record.setValue(place.type, forKey: "type")
        record.setValue(place.location, forKey: "location")
        record.setValue(place.phone, forKey: "phone")
        record.setValue(place.web, forKey: "web")
        
        if let originalImage = UIImage(data: place.image as! Data) {
            let scaleFactor = (originalImage.size.width > 1024) ? 1024/originalImage.size.width : 1.0
            let scaledImage = UIImage(data: place.image as! Data, scale: scaleFactor)
            
            
        }
        
        
    }
    
    @IBAction func reatingPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.rating = "dislike"
            self.likeButton.backgroundColor = defaultColor
            self.dislikeButton.backgroundColor = selectedColor
            self.loveButton.backgroundColor = defaultColor
        case 1:
            self.rating = "good"
            self.likeButton.backgroundColor = selectedColor
            self.dislikeButton.backgroundColor = defaultColor
            self.loveButton.backgroundColor = defaultColor
        case 2:
            self.rating = "great"
            self.likeButton.backgroundColor = defaultColor
            self.dislikeButton.backgroundColor = defaultColor
            self.loveButton.backgroundColor = selectedColor
        default:
            break
        }
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
