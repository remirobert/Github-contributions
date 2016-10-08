//
//  InterfaceController.swift
//  Github-contribution-watch Extension
//
//  Created by Remi Robert on 05/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var imageView: WKInterfaceImage!
    @IBOutlet var labelNumberContributions: WKInterfaceLabel!
    @IBOutlet var labelContributions: WKInterfaceLabel!
    
    private let request = GithubRequest()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    fileprivate func updateData(dataCount: Int, color: UIColor) {
        self.labelContributions.setHidden(false)
        self.labelNumberContributions.setTextColor(color)
        self.labelNumberContributions.setText("\(dataCount)")
    }
    
    fileprivate func performRequest(username: String) {
        self.request.contributions(username: username) { contributions in
            guard let today = contributions?.last else {
                return
            }
            let dataCount = today.dataCount
            ApplicationDatas.sharedInstance.todayDataCount = dataCount
            ApplicationDatas.sharedInstance.todayColor = today.color
            
            let complicationServer = CLKComplicationServer.sharedInstance()
            for complication in complicationServer.activeComplications ?? [] {
                complicationServer.reloadTimeline(for: complication)
            }
            
            DispatchQueue.main.async {
                self.updateData(dataCount: dataCount, color: UIColor.initFrom(hex: today.color))
            }
        }
    }
    
    @IBAction func refresh() {
        guard let username = ApplicationDatas.sharedInstance.username else {
            return
        }
        self.performRequest(username: username)
    }
    
    override func willActivate() {
        super.willActivate()
        
        WatchSessionManager.default.delegate = self
        
        self.labelNumberContributions.setText("¯\\_(ツ)_/¯")
        self.labelContributions.setHidden(true)
        
        if let count = ApplicationDatas.sharedInstance.todayDataCount,
            let color = ApplicationDatas.sharedInstance.todayColor {
            self.updateData(dataCount: count, color: UIColor.initFrom(hex: color))
        }
        self.refresh()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension InterfaceController: WatchSessionManagerDelegate {
    func didUpdate() {
        let username = ApplicationDatas.sharedInstance.username
        let dataCount = ApplicationDatas.sharedInstance.todayDataCount
        let color = UIColor.initFrom(hex: ApplicationDatas.sharedInstance.todayColor ?? "")
        self.updateData(dataCount: dataCount ?? 0, color: color)
        print("username application datas: \(username)")
        print("data count application count : \(dataCount)")
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("current state conectivity : \(activationState)")
        print("error : \(error)")
    }
}


