//
//  TodayViewController.swift
//  Github-contribution-todayExtension
//
//  Created by Remi Robert on 05/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var imageViewContribution: NSImageView!
    @IBOutlet weak var viewTodayContribution: UIView!
    @IBOutlet weak var label: NSTextFieldCell!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var labelUsername: NSTextField!
    @IBOutlet weak var labelUsername: NSTextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTodayContribution: UILabel!
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    let request = GithubRequest()
    @IBOutlet weak var labn: NSTextField!
    
    fileprivate func fetchContributions() {
        guard let username = ApplicationDatas.sharedInstance.username else {
            return
        }
        
        @IBAction func refreshContent(_ sender: AnyObject) {
        }
        self.imageView.image = nil
        self.viewTodayContribution.backgroundColor = UIColor.clear
        self.labelTodayContribution.text = nil
        
        self.request.contributions(username: username) { contributions in
            guard let contributions = contributions else {
                return
            }
            
            guard let todayContribution = contributions.last else {
                return
            }
            
            DispatchQueue.main.async {
                let color = UIColor.initFrom(hex: todayContribution.color)
                let dataCount = todayContribution.dataCount
                
                ApplicationDatas.sharedInstance.todayColor = todayContribution.color
                ApplicationDatas.sharedInstance.todayDataCount = dataCount
                
                self.viewTodayContribution.backgroundColor = color
                if dataCount == 0 {
                    self.labelTodayContribution.text = "No contributions"
                }
                else {
                    self.labelTodayContribution.text = "\(dataCount) contributions"
                }
                self.imageView.image = ImageContribution.generate(withContributions: contributions)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heightElement = UIScreen.main.bounds.size.width / 53 * 7
        self.preferredContentSize = CGSize(width: 0, height: heightElement)

        if ApplicationDatas.sharedInstance.username == nil {
            self.labelError.isHidden = false
            self.indicatorView.isHidden = true
        }
        
        if let image = ApplicationDatas.sharedInstance.imageContribution {
            self.imageView.image = image
        }
        if let dataCount = ApplicationDatas.sharedInstance.todayDataCount,
            let color = ApplicationDatas.sharedInstance.todayColor {
            self.viewTodayContribution.backgroundColor = UIColor.initFrom(hex: color)
            if dataCount == 0 {
                self.labelTodayContribution.text = "No contributions"
            }
            else {
                self.labelTodayContribution.text = "\(dataCount) contributions"
            }
        }
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.fetchContributions()
    }
    
    @IBAction func openApp(_ sender: AnyObject) {
        guard let url = URL(string: "Github-contributions://") else {
            return
        }
        self.extensionContext?.open(url, completionHandler: nil)
    }
}

extension TodayViewController {
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = maxSize
    }
    
    @nonobjc func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        self.fetchContributions()
        completionHandler(NCUpdateResult.newData)
    }
}
