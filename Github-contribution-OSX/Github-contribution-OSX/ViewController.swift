//
//  ViewController.swift
//  Github-contribution-OSX
//
//  Created by Remi Robert on 08/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Foundation
import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageViewContribution: NSImageView!
    @IBOutlet weak var textfieldUsername: NSTextField!
    @IBOutlet weak var viewColorContribution: NSView!
    @IBOutlet weak var textfieldDataCount: NSTextField!
    
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var containerViewUsername: NSView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    fileprivate var request = GithubRequest()
    
    fileprivate func updateTodayContribution(contribution: Contribution) {
        self.textfieldDataCount.stringValue = "\(contribution.dataCount) contributions today."
        self.viewColorContribution.layer?.backgroundColor = NSColor.initFrom(hex: contribution.color).cgColor
        
        ApplicationDatas.sharedInstance.todayColor = contribution.color
        ApplicationDatas.sharedInstance.todayDataCount = contribution.dataCount
    }
    
    @IBAction func didEnterUsername(_ sender: AnyObject) {
        self.textfieldUsername.resignFirstResponder()
        if self.textfieldUsername.stringValue.characters.count > 0 {
            let username = self.textfieldUsername.stringValue
            self.fetchContributions(username: username)
            ApplicationDatas.sharedInstance.username = username
        }
    }
    
    private func fetchContributions(username: String) {
        self.imageViewContribution.image = nil
        self.progressIndicator.startAnimation(nil)
        self.viewColorContribution.layer?.backgroundColor = NSColor.clear.cgColor
        self.textfieldDataCount.stringValue = "¯\\_(ツ)_/¯"
        self.request.contributions(username: username) { contributions in
            DispatchQueue.main.async {
                self.progressIndicator.stopAnimation(nil)
            }
            guard let contributions = contributions else {
                return
            }
            DispatchQueue.main.async {
                self.viewColorContribution.layer?.backgroundColor = NSColor.clear.cgColor
                self.textfieldDataCount.stringValue = ""
                let image = ImageContribution.generate(withContributions: contributions)
                ApplicationDatas.sharedInstance.imageContribution = image
                self.imageViewContribution.image = image
            }
            
            guard let todayContribution = contributions.last else {
                return
            }
            
            DispatchQueue.main.async {
                self.updateTodayContribution(contribution: todayContribution)
            }
        }
    }
    
    private func initDefaultData() {
        self.textfieldUsername.stringValue = ApplicationDatas.sharedInstance.username ?? ""
        if let image = ApplicationDatas.sharedInstance.imageContribution {
            self.imageViewContribution.image = image
        }
        if let color = ApplicationDatas.sharedInstance.todayColor,
            let dataCount = ApplicationDatas.sharedInstance.todayDataCount {
            self.viewColorContribution.layer?.backgroundColor = NSColor.initFrom(hex: color).cgColor
            self.textfieldDataCount.stringValue = "\(dataCount) contributions today"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldDataCount.stringValue = "¯\\_(ツ)_/¯"
        self.textfieldUsername.resignFirstResponder()
        self.textfieldUsername.placeholderString = "username github"
        self.textfieldUsername.delegate = self
        
        self.containerView.layer?.backgroundColor = NSColor.white.cgColor
        self.containerView.layer?.borderWidth = 1
        self.containerView.layer?.borderColor = NSColor.lightGray.cgColor
        
        self.containerViewUsername.layer?.backgroundColor = NSColor.white.cgColor
        self.containerViewUsername.layer?.borderWidth = 1
        self.containerViewUsername.layer?.borderColor = NSColor.lightGray.cgColor
        
        self.initDefaultData()
        guard let username = ApplicationDatas.sharedInstance.username else {
            return
        }
        self.fetchContributions(username: username)
    }

    override var representedObject: Any? {
        didSet {
        }
    }
}

extension ViewController: NSTextFieldDelegate {
    
}
