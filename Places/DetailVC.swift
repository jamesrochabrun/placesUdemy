//
//  DetailVC.swift
//  places
//
//  Created by James Rochabrun on 12/1/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit
import MessageUI

class DetailVC: UIViewController {

    @IBOutlet weak var placeImageView: UIImageView!
    var place: Place!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        DispatchQueue.main.async { [weak self] in
            self?.placeImageView.image = UIImage(data: self?.place.image as! Data)
            self?.title = self?.place.name
        }
        
        self.tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    
        if let image = self.place.rating {
            self.ratingbutton.setImage(UIImage(named: image), for:.normal)
        }
        
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
        self.hidesBottomBarWhenPushed = true

    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
        if let reviewVC = segue.source as? ReviewVC {
            
            if let rating = reviewVC.ratingSelected {
                print(rating)
                self.place.rating = rating
                if let image = self.place.rating {
                    self.ratingbutton.setImage(UIImage(named: image), for:.normal)
                    
                    //update coredata
                    if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                        
                        let context = container.viewContext
                        do {
                            try context.save()
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMap" {
            let destinationVC = segue.destination as! MapVC
            destinationVC.place = self.place
        }
    }


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
            cell.valueLabel.text = self.place.phone
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            //geolocation stuf
            self.performSegue(withIdentifier: "showMap", sender: nil)
        case 3:
            //send SMS
            let alertController = UIAlertController(title: "SMS", message: "send sms to...\(self.place.name)", preferredStyle: .actionSheet)
            let smsAction = UIAlertAction(title: "SMS", style: .default, handler: { (action) in
                self.sendSMS()
            })
            alertController.addAction(smsAction)
            
            let callAction = UIAlertAction(title: "Call", style: .default, handler: { (action) in
                self.callPhone()
            })
            alertController.addAction(callAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        case 4:
            //open website
            self.goToWeb()
        default:
            break
        }
    }
    
    func goToWeb() {
        // if let websiteURL = self.place.web {
        if let url = URL(string: "https://www.facebook.com/") {
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
            //  }
        }
    }
    
    func callPhone() {
        if let phoneNumber = self.place.phone {
            if let phoneURL = URL(string: "tel://\(phoneNumber)") {
                let app = UIApplication.shared
                if app.canOpenURL(phoneURL) {
                    app.open(phoneURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func sendSMS() {
        if MFMessageComposeViewController.canSendText() {
            let message = "Hi this is a message"
            let msgVC = MFMessageComposeViewController()
            msgVC.body = message
            msgVC.messageComposeDelegate = self
            if let phone = self.place.phone {
                msgVC.recipients = [phone]
            }
            self.present(msgVC, animated: true, completion: nil)
        }
        
    }
    
}

extension DetailVC : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        print(result)
        controller.dismiss(animated: true, completion: nil)
        
    }
}








