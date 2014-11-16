//
//  ViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 2014/11/15.
//  Copyright (c) 2014 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ContentViewControllerDelegate, MenuTableViewControllerDelegate {
    
    var contentViewController : ContentViewController! = nil
    var menuTableViewController : MenuTableViewController! = nil
    var navController : UINavigationController! = nil
    var menuShowed : Bool = false
    var effectView : UIVisualEffectView! = nil
    override func viewDidLoad() {
        
        contentViewController = storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as ContentViewController
        contentViewController.delegate = self
        
        navController = UINavigationController(rootViewController: contentViewController)
        addChildViewController(navController)
        view.addSubview(navController.view)
        navController.didMoveToParentViewController(self)
        
        menuTableViewController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewContrller") as MenuTableViewController
        addChildViewController(menuTableViewController)
        menuTableViewController.tableView.frame.size.width = 200
        menuTableViewController.tableView.frame.origin.x = self.view.frame.origin.x - menuTableViewController.tableView.frame.size.width
        menuTableViewController.delegate = self
        
        view.addSubview(menuTableViewController.tableView)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performMenuButton(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            let originX : CGFloat = self.menuShowed ? self.menuOriginX() : self.menuOriginX() + 200.0 as CGFloat
            self.menuTableViewController.tableView.frame.origin.x = originX

        }, completion: { finished in
            self.menuShowed = !self.menuShowed
        });
    }
    
    func menuTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            let originX : CGFloat = self.menuOriginX() as CGFloat
            self.menuTableViewController.tableView.frame.origin.x = originX
        }, completion: { finished in
            self.menuShowed = false
        });
    }

    
    func  menuOriginX() -> CGFloat {
        return self.view.frame.origin.x - self.menuTableViewController.tableView.frame.size.width
    }

    @IBAction func PerformPanGesture(sender: UIPanGestureRecognizer) {
        let recognizer = sender
        if menuTableViewController.view.frame.origin.x == -200 {
           return
        }
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            var pos: CGFloat = menuTableViewController.view.frame.origin.x > -100 ? 0: -200
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.menuTableViewController.tableView.frame.origin.x = pos
                }, completion: { finished in
                    self.menuShowed = pos == 0 ? true: false
            });
        } else {
            if menuTableViewController.view.frame.origin.x <= 0 && menuTableViewController.view.frame.origin.x >= -200 {
                let translation = recognizer.translationInView(self.view)
                if menuTableViewController.view.frame.origin.x + translation.x > 0 {
                    menuTableViewController.view.frame.origin.x = 0
                } else {
                    menuTableViewController.view.center = CGPoint(x: menuTableViewController.view.center.x + translation.x, y: menuTableViewController.view.center.y)
                }
                recognizer.setTranslation(CGPointZero, inView: self.view)
            }
        }

    }
    
    @IBAction func performScreenEdgePanGesture(sender: AnyObject) {
        println("aaaa")
        let recognizer = sender as UIScreenEdgePanGestureRecognizer
        if recognizer.state == UIGestureRecognizerState.Ended {
            var pos: CGFloat = menuTableViewController.view.frame.origin.x > -100 ? 0: -200
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.menuTableViewController.tableView.frame.origin.x = pos
                }, completion: { finished in
                    self.menuShowed = pos == 0 ? true: false
            });
        } else {
            if menuTableViewController.view.frame.origin.x <= 0 && menuTableViewController.view.frame.origin.x >= -200 {
                let translation = recognizer.translationInView(self.view)
                if menuTableViewController.view.frame.origin.x + translation.x > 0 {
                    menuTableViewController.view.frame.origin.x = 0
                } else {
                    menuTableViewController.view.center = CGPoint(x: menuTableViewController.view.center.x + translation.x, y: menuTableViewController.view.center.y)
                }
                recognizer.setTranslation(CGPointZero, inView: self.view)
            }
        }
    }
}

