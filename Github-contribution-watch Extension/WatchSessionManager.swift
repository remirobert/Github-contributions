//
//  WatchSessionManager.swift
//  Github-contribution
//
//  Created by Remi Robert on 07/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import WatchConnectivity

protocol WatchSessionManagerDelegate {
    func didUpdate()
}

class WatchSessionManager: NSObject {
    
    static let `default` = WatchSessionManager()
    fileprivate let session: WCSession = WCSession.default()
    var delegate: WatchSessionManagerDelegate?
    
    override init() {
        super.init()
        self.session.delegate = self
        self.session.activate()
        print("📢 session appliucation username : \(self.session.applicationContext["username"])")
    }
}

extension WatchSessionManager: WCSessionDelegate {
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("did get connection : \(activationState.rawValue)")
        print("error \(error)")
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("🐹 get application context : \(applicationContext)")
        guard let username = applicationContext["username"] as? String,
            let dataCount = applicationContext["dataCount"] as? Int,
            let color = applicationContext["color"] as? String else {
            return
        }
        ApplicationDatas.sharedInstance.username = username
        ApplicationDatas.sharedInstance.todayDataCount = dataCount
        ApplicationDatas.sharedInstance.todayColor = color
        DispatchQueue.main.async {
            self.delegate?.didUpdate()
        }
    }
}
