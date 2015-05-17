//
//  PageNavigationViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 3/29/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

protocol PageSwipeViewControllerDelegate: class {
}

class PageSwipeViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, NavigationMenuScrollViewDelegate {
    
    private var pages: [UIViewController] = []
    private var titles: [String] = ["記事新着", "記事検索", "話題のアプリ", "お気に入り", "履歴", "レビューリスト", "おすすめアプリ", "設定"]
    private var currentIndex = 0
    
    private var pageViewController : UIPageViewController?
    private var navScrollView : NavigationMenuScrollView?
    
    weak var navigationDelegate : PageSwipeViewControllerDelegate?
    
    
    convenience init(viewControllers : [UIViewController], titles :[String], delegate: PageSwipeViewControllerDelegate) {
        self.init()
        self.pages = viewControllers
        self.titles = titles
        self.navigationDelegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        if let pageVc = pageViewController {
            pageVc.delegate = self
            pageVc.dataSource = self
            pageVc.setViewControllers([self.pages[0]], direction: .Forward, animated: true, completion: nil)
            self.addChildViewController(pageVc)
            self.view.addSubview(pageVc.view)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.backBarButtonItem?.title = "あああ"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.navScrollView != nil {
            return
        }
        
        if let navBar = self.navigationController?.navigationBar {
            self.navScrollView = UINib(nibName: "NavigationMenuScrollView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? NavigationMenuScrollView
            self.navScrollView?.menuDelegate = self
            if let navScrollView = self.navScrollView {
                navScrollView.frame = CGRectMake(0, 0, navBar.frame.width, navBar.frame.height)
                navScrollView.backgroundColor = UIColor.clearColor()
                navBar.addSubview(navScrollView)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navScrollView?.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navScrollView?.hidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if var index = self.indexOfViewController(viewController) {
            self.currentIndex = index
            self.navScrollView?.transitMenuHighlight(index)
            switch ++index {
                case 0..<self.pages.count:
                    return self.pages[index]
                default:
                    return nil
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if var index = self.indexOfViewController(viewController) {
            self.currentIndex = index
            self.navScrollView?.transitMenuHighlight(index)
            switch --index {
            case 0..<self.pages.count:
                return self.pages[index]
            default:
                return nil
            }
        }
        return nil
    }
    
    func indexOfViewController(viewController : UIViewController) -> Int? {
        if let index = find(pages, viewController) {
            return index
        } else {
            return nil
        }
    }
    
    func navigationMenuScrollView(scrollView: NavigationMenuScrollView, touchUpMenuButton menuButton: UIButton) {
        let nextIndex = menuButton.tag - 1
        println(nextIndex)
        println(self.currentIndex)
        var direction = UIPageViewControllerNavigationDirection.Forward
        if nextIndex < self.currentIndex {
            direction = UIPageViewControllerNavigationDirection.Reverse
        } else if nextIndex > self.currentIndex {
            direction = UIPageViewControllerNavigationDirection.Forward
        } else {
            return;
        }
        self.pageViewController?.setViewControllers([self.pages[nextIndex]], direction: direction, animated: true, completion: { (completion) -> Void in
        })
        self.currentIndex = nextIndex
    }
}
