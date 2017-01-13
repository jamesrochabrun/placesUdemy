//
//  ProfileVC.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import SafariServices
class ProfileVC: UITableViewController {

    let sections = ["add valoration", "follow us"]
    let sectionContent = [["appstore", "feedback"], ["facebook", "twitter"]]
    
    let sectionLinks = [["https://itunes.apple.com/us/app/copa-club-copa-america-live/id1111302609?mt=8", "https://es.foursquare.com/roch4brun"],
                        ["https://facebook.com", "https://twitter.com"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return self.sectionContent[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        // Configure the cell...
        let content = self.sectionContent[indexPath.section][indexPath.row]
        cell.textLabel?.text = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.sections[section]
        return title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let appStoreURL = URL(string: self.sectionLinks[indexPath.section][indexPath.row]) {
                    let app = UIApplication.shared
                    if app.canOpenURL(appStoreURL) {
                        app.open(appStoreURL, options: [:], completionHandler: nil)
                    }
                }
            case 1:
                performSegue(withIdentifier: "showWeb", sender: self.sectionLinks[indexPath.section][indexPath.row])
            default:
                break
            }
        case 1: //social networks
            if let url = URL(string: self.sectionLinks[indexPath.section][indexPath.row]) {
                let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(safariVC, animated: true, completion: nil)
            }
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showWeb" {
            let destinationVC = segue.destination as! WebViewVC
            destinationVC.urlName = sender  as! String
        }
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

    
 

}
