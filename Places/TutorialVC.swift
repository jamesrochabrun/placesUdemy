//
//  TutorialVC.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentImageview: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    var tutorialStep: TutorialStep!
    
    @IBOutlet weak var tutorialControl: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = self.tutorialStep.heading
        self.contentLabel.text = self.tutorialStep.content
        self.contentImageview.image = self.tutorialStep.image
        self.tutorialControl.currentPage = self.tutorialStep.index
        // Do any additional setup after loading the view.
        
        switch self.tutorialStep.index {
        case 0...1:
            self.nextButton.setTitle("Next", for: .normal)
        case 2:
            self.nextButton.setTitle("Finish", for: .normal)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextPressed(_ sender: UIButton) {
        switch self.tutorialStep.index {
        case 0...1:
            
            let pageVC = parent as! TutorialPageVC
            pageVC.forward(toIndex: self.tutorialStep.index)
        case 2:
            self.dismiss(animated: true, completion: nil)
        default:
            break
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
