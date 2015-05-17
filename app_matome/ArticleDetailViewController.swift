//
//  ArticleDetailViewController.swift
//  app_matome
//
//  Created by Kazuhiro Hayashi on 3/8/15.
//  Copyright (c) 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {

    var webView :WKWebView?
    var loadUrl : NSURL = NSURL()
    var scrollViewTranslation :CGFloat? = 0.0
    var navOriginY : CGFloat = 0.0
    var navMinY : CGFloat = 0.0
    var webViewTitle : String = ""
    var progressView : UIView = UIView(frame: CGRectZero)
    var progressBarView : UIView = UIView(frame: CGRectZero)
    var animating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView()
        self.view = self.webView
        if let webView = self.webView {
            webView.loadRequest(NSURLRequest(URL: self.loadUrl))
            webView.scrollView.delegate = self
            webView.navigationDelegate = self
            let navBar = self.navigationController?.navigationBar
            navOriginY = navBar!.frame.origin.y
            navMinY = webView.frame.origin.y - (navBar!.frame.size.height - UIApplication.sharedApplication().statusBarFrame.height)
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
            webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        }
        
        var slice = CGRectZero
        var reminder = CGRectZero
        if let bounds = self.navigationController?.navigationBar.bounds {
            CGRectDivide(bounds, &slice, &reminder, 2.5, CGRectEdge.MaxYEdge)
            progressView.frame = slice
            progressView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
            progressBarView.frame = CGRectMake(0, 0, 0, progressView.frame.height)
            progressView.addSubview(progressBarView)
            self.navigationController?.navigationBar.addSubview(progressView)
        }
        self.navigationItem.backBarButtonItem?.title = nil
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView?.scrollView.delegate = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.progressView.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressView.hidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView?.removeObserver(self, forKeyPath: "title")
        self.progressView.removeFromSuperview()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let webView = self.webView {
            var point : CGPoint? = webView.scrollView.panGestureRecognizer.translationInView(webView)
            scrollViewTranslation = point?.y
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let webView = self.webView {
            let currentTranslation = scrollView.panGestureRecognizer.translationInView(webView).y
            if let navBar = self.navigationController?.navigationBar {
                let nextOriginY = navBar.frame.origin.y + (currentTranslation - scrollViewTranslation!)
                if nextOriginY >= navOriginY || scrollView.contentOffset.y <= -(navBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height) {
                    navBar.frame.origin.y = navOriginY
                    self.clearNavigationItems(false)
                } else if nextOriginY <= navMinY {
                    navBar.frame.origin.y = navMinY
                    self.clearNavigationItems(true)
                } else {
                    navBar.frame.origin.y = nextOriginY
                    self.clearNavigationItems(false)
                }
                scrollViewTranslation = currentTranslation
            }

        }

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewTranslation = 0.0
    }
        
    func clearNavigationItems(bool : Bool) {
        self.navigationItem.setHidesBackButton(bool, animated: false)
        self.navigationItem.title = (bool ? nil : self.webViewTitle)
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "estimatedProgress":
            if let progress = change[NSKeyValueChangeNewKey] as? CGFloat {
                if animating != true {
                    animating = true
                    weak var weakSelf = self
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.progressBarView.frame = CGRectMake(self.progressBarView.frame.origin.x, self.progressBarView.frame.origin.y, self.setProgresss(progress).width, self.progressBarView.frame.size.height)
                        }, completion: { (bool) -> Void in
                            self.animating = false
                    })
                }
                self.progressBarView.backgroundColor = UIColor.purpleColor()

            }
        case "title":
            if let title = change[NSKeyValueChangeNewKey] as? NSString {
                self.webViewTitle = title
                self.navigationItem.title = title
            }
        default:
            break
        }
    }
    
    func setProgresss(progress : CGFloat) -> CGRect{
        println(progress)
        var _progress : CGFloat
        if progress <= 0 {
            _progress = 0
        } else if progress >= 1 {
            _progress = 1
        } else {
            _progress = progress
        }
        var slice = CGRectZero
        var reminder = CGRectZero
        var width = self.progressView.bounds.width * _progress
        CGRectDivide(self.progressView.bounds, &slice, &reminder, width, CGRectEdge.MinXEdge)
        return slice
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.progressBarView.frame = CGRectMake(self.progressBarView.frame.origin.x, self.progressBarView.frame.origin.y, self.progressView.frame.width, self.progressBarView.frame.height)
        })
        UIView .animateWithDuration(0.5, animations: { () -> Void in
            self.progressBarView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
            }, completion: { (bool) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.progressBarView.frame = CGRectZero
        })
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        UIView .animateWithDuration(0.5, animations: { () -> Void in
            self.progressBarView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
            }, completion: { (bool) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.progressBarView.frame = CGRectZero
        })
    }
}
