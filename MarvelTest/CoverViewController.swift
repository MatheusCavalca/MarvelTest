//
//  CoverViewController.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet var customPagingView: UIView!
    @IBOutlet var coversScrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    
    var appearance: Appearance!
    
    var nLoadedImages: Int = 0
    var page: Int = 0
    var coverViews = [UIView]()
    
    var coverViewsPadding: CGFloat {
        get {
            return coversScrollView.frame.origin.x
        }
    }
    
    let imageTag = 100
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContent()
        configPageLabel()
        loadCovers()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Configuration
    
    func configContent() {
        titleLabel.text = appearance.title
        coversScrollView.delegate = self
        coversScrollView.clipsToBounds = false
        customPagingView.addGestureRecognizer(coversScrollView.panGestureRecognizer)
    }
    
    func configPageLabel() {
        if nLoadedImages > 0 {
            pageLabel.text = (page + 1).description + "/" + nLoadedImages.description
        } else {
            pageLabel.text = "No images to show"
        }
    }
    
    // MARK: - Images Helper
    
    func loadCovers() {
        if let imagePathes = appearance.imagesPathes {
            for i in 0 ..< imagePathes.count {
                loadImage(imagePathes[i])
            }
        }
    }
    
    func loadImage(imagePath: String) {
        getDataFromUrl(NSURL(string: imagePath)!, completion: { (data, response, error) in
            if let dataUnw = data {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    let nibName = NibObjects.reuseIdentifierFor(.CoverView)
                    let nib = UINib(nibName: nibName, bundle: NSBundle.mainBundle())
                    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
                    
                    let imageView = view.viewWithTag(self.imageTag) as! UIImageView
                    imageView.image = UIImage(data: dataUnw)
                    
                    var floatLoadedImages = CGFloat(self.nLoadedImages)
                    view.frame = CGRectMake(self.coversScrollView.frame.size.width * floatLoadedImages, 0, self.coversScrollView.frame.size.width, self.coversScrollView.frame.size.height)
                    view.tag = self.nLoadedImages
                    
                    self.nLoadedImages += 1
                    floatLoadedImages += 1.0
                    
                    self.configPageLabel()
                    
                    self.coversScrollView.contentSize = CGSizeMake(self.coversScrollView.frame.size.width * floatLoadedImages, self.coversScrollView.frame.size.height)
                    
                    if floatLoadedImages > 1 {
                        self.coversScrollView.scrollEnabled = true
                        view.alpha = 0.2
                    } else {
                        view.alpha = 1.0
                        self.coversScrollView.scrollEnabled = false
                    }
                    
                    self.coversScrollView.addSubview(view)
                    self.coverViews.append(view)
                })
            }
        })
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    // MARK: - Action
    
    @IBAction func cancelDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension CoverViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.size.width
        page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let coeficientContent = (scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)
        let coeficientPag = coeficientContent - CGFloat(page)
        
        print(coeficientPag)
        print(page)

        let currentView = coverViews[page]
        print(currentView.tag)
        
        if coeficientPag <= 0.5 {
            currentView.alpha = coeficientPag * 2 + 0.2
        } else {
            currentView.alpha = 1 - coeficientPag + 0.2
        }
        
        configPageLabel()
    }
    
}
