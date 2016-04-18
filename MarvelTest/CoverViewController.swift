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
    
    @IBOutlet var coversScrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    
    var appearance: Appearance!
    
    var nLoadedImages: Int = 0
    var page: Int = 0
    
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
                    self.coversScrollView.addSubview(view)
                    
                    var floatLoadedImages = CGFloat(self.nLoadedImages)
                    view.frame = CGRectMake(self.coversScrollView.frame.size.width * floatLoadedImages, 0, self.coversScrollView.frame.size.width, self.coversScrollView.frame.size.height)
                    
                    self.nLoadedImages += 1
                    floatLoadedImages += 1.0
                    
                    self.configPageLabel()
                    
                    self.coversScrollView.contentSize = CGSizeMake(self.coversScrollView.frame.size.width * floatLoadedImages, self.coversScrollView.frame.size.height)
                    
                    if floatLoadedImages > 1 {
                        self.coversScrollView.scrollEnabled = true
                    } else {
                        self.coversScrollView.scrollEnabled = false
                    }
                    
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
        let pageWidth:CGFloat = coversScrollView.frame.size.width
        page = Int(floor((coversScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        configPageLabel()
    }
    
}
