//
//  TodayViewController.swift
//  Github-contribution-OSX-widget
//
//  Created by Remi Robert on 08/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    private let request = GithubRequest()
    
    @IBOutlet weak var imageview: NSImageView!
    @IBOutlet weak var textfieldContribution: NSTextField!
    @IBOutlet weak var viewContributionColor: NSView!
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    private func updateLocalDatas() {
        self.imageview.image = ApplicationDatas.sharedInstance.imageContribution
        if let dataCount = ApplicationDatas.sharedInstance.todayDataCount,
            let color = ApplicationDatas.sharedInstance.todayColor {
            self.viewContributionColor.layer?.backgroundColor = NSColor.initFrom(hex: color).cgColor
            self.textfieldContribution.stringValue = "\(dataCount) contributions today."
        }
    }
    
    private func fetchContributions() {
        guard let username = ApplicationDatas.sharedInstance.username else {
            return
        }
        self.request.contributions(username: username) { contributions in
            guard let contributions = contributions else {
                return
            }
            
            let image = ImageContribution.generate(withContributions: contributions)
            ApplicationDatas.sharedInstance.imageContribution = image
            self.imageview.image = image
            
            if let today = contributions.last {
                ApplicationDatas.sharedInstance.todayDataCount = today.dataCount
                ApplicationDatas.sharedInstance.todayColor = today.color
                self.textfieldContribution.stringValue = "\(today.dataCount) contributions today."
                self.viewContributionColor.layer?.backgroundColor = NSColor.initFrom(hex: today.color).cgColor
            }
            self.textfieldContribution.stringValue = "request ok"
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.fetchContributions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = NSSize(width: self.preferredMaximumSize.width, height: 90)
        self.textfieldContribution.stringValue = "¯\\_(ツ)_/¯"
        self.updateLocalDatas()
    }

    func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        self.updateLocalDatas()
        completionHandler(.newData)
        print("updated")
    }
}
