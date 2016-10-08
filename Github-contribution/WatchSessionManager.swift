//
//  WatchSessionManager.swift
//  Github-contribution
//
//  Created by Remi Robert on 07/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchSessionManager: NSObject {
    
    static var `default` = WatchSessionManager()
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    func startSession() {
        self.session?.delegate = self
        self.session?.activate()
    }
}

extension WatchSessionManager: WCSessionDelegate {
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("🤖 session manager connection state : \(activationState.rawValue)")
    }
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    public func sessionDidDeactivate(_ session: WCSession) {}
}

extension WatchSessionManager {
    func save(data: [String: Any]) {
        do {
            try self.session?.updateApplicationContext(data)
        }
        catch {
            print("⚠️ issue while updating application context")
        }
    }
}
