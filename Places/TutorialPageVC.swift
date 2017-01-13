//
//  TutorialPageVC.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class TutorialPageVC: UIPageViewController {

    var tutorialSteps: [TutorialStep] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstStep = TutorialStep(index: 0, heading: "Customize", content: "create a new place", image:#imageLiteral(resourceName: "tuto-intro-1"))
        self.tutorialSteps.append(firstStep)
        let secondStep = TutorialStep(index: 1, heading: "Find", content: "Find and locate your favorite places", image: #imageLiteral(resourceName: "tuto-intro-2"))
        self.tutorialSteps.append(secondStep)
        let thirdStep = TutorialStep(index: 2, heading: "Discover", content: "Discover new places around you", image: #imageLiteral(resourceName: "tuto-intro-3"))
        self.tutorialSteps.append(thirdStep)
        self.dataSource = self
        if let startVC = self.pageViewController(atIndex: 0) {
            setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func forward(toIndex:Int)  {
        
        if let nextVC = self.pageViewController(atIndex: toIndex + 1) {
            self.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
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

extension TutorialPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialVC).tutorialStep.index
        index -= 1
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialVC).tutorialStep.index
        index += 1
        return self.pageViewController(atIndex: index)
    }
    
    func pageViewController(atIndex: Int) -> TutorialVC? {
        
        if atIndex == NSNotFound || atIndex < 0 || atIndex >= self.tutorialSteps.count {
            return nil
        }
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "TutorialController") as? TutorialVC {
            pageContentVC.tutorialStep = self.tutorialSteps[atIndex]
            return pageContentVC
        }
        return nil
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.tutorialSteps.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        
//        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "TutorialController") as? TutorialVC {
//            if let tutorialStep = pageContentVC.tutorialStep {
//                return tutorialStep.index
//            }
//        }
//        return 0
//    }
    
    
}











