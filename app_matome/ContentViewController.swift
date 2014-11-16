//
//  ContentViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 2014/11/15.
//  Copyright (c) 2014 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var delegate: ContentViewControllerDelegate!
    
    @IBOutlet weak var articleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    

    @IBAction func performMenuButton(sender: AnyObject) {
        delegate.performMenuButton(sender)
    }
}

protocol ContentViewControllerDelegate {
    func performMenuButton(AnyObject) -> Void
}