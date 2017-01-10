//
//  ReviewViewController.swift
//  places
//
//  Created by James Rochabrun on 12/1/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var ratingstackview: UIStackView!
    var ratingSelected : String?
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var greatButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let blur = UIBlurEffect(style:.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        backgroundView.addSubview(blurView)
        
        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let translate = CGAffineTransform(translationX: 0.0, y: 500)
        
        //ratingstackview.transform = scale.concatenating(translate)
    
        self.dislikeButton.transform = scale.concatenating(translate)
        self.greatButton.transform = scale.concatenating(translate)
        self.likeButton.transform = scale.concatenating(translate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:{
        //            self.ratingstackview.transform = CGAffineTransform.identity
        //        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations:{
            //self.ratingstackview.transform = CGAffineTransform.identity
            self.dislikeButton.transform = CGAffineTransform.identity
        }, completion: { (success) in
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations:{
                //self.ratingstackview.transform = CGAffineTransform.identity
                self.greatButton.transform = CGAffineTransform.identity
            }, completion: { (success) in
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations:{
                    //self.ratingstackview.transform = CGAffineTransform.identity
                    self.likeButton.transform = CGAffineTransform.identity
                }, completion: nil)
                
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ratingPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            ratingSelected = "dislike"
        case 2:
            ratingSelected = "great"
        case 3:
            ratingSelected = "good"
        default:
            break
        }
        
        performSegue(withIdentifier: "unwind", sender: sender)
        
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
