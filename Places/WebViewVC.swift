//
//  webViewVC.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {
    @IBOutlet weak var webview: UIWebView!
    var urlName: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlName) {
            let request = URLRequest(url: url)
            self.webview.loadRequest(request)
        }
        print(urlName)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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









