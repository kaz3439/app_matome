//
//  ViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 2014/11/15.
//  Copyright (c) 2014 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PageSwipeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let articleVc = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc2 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc3 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc4 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc5 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc6 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc7 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        let articleVc8 = self.storyboard?.instantiateViewControllerWithIdentifier("ArticleMasterViewController") as ArticleMasterViewController
        
        var pageViewController = PageSwipeViewController(viewControllers: [articleVc, articleVc2, articleVc3, articleVc4, articleVc5, articleVc6, articleVc7, articleVc8], titles: ["新着情報", "新着情報"], delegate: self)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        var navController = UINavigationController(rootViewController: pageViewController)
        addChildViewController(navController)
        view.addSubview(navController.view)
        navController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

