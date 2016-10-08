//
//  GithubInformations.swift
//  GithubContributionsDatas
//
//  Created by Remi Robert on 06/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Foundation
import UIKit

let groupId = "group.githubcontributions"

public class ApplicationDatas {
    private let userDefaults: UserDefaults
    public static var sharedInstance = ApplicationDatas(userDefaults: UserDefaults(suiteName: groupId)!)
    
    public var username: String? {
        get {
            return self.userDefaults.string(forKey: "username")
        }
        set {
            self.userDefaults.set(newValue, forKey: "username")
            self.userDefaults.synchronize()
        }
    }
    
    public var imageContribution: UIImage? {
        get {
            guard let data = self.userDefaults.data(forKey: "image") else {
                return nil
            }
            return UIImage(data: data)
        }
        set {
            guard let image = newValue else {
                return
            }
            let data = UIImagePNGRepresentation(image)
            self.userDefaults.set(data, forKey: "image")
            self.userDefaults.synchronize()
        }
    }
    
    public var todayColor: String? {
        get {
            return self.userDefaults.string(forKey: "color")
        }
        set {
            guard let color = newValue else {
                return
            }
            self.userDefaults.set(color, forKey: "color")
        }
    }
    
    public var todayDataCount: Int? {
        get {
            return self.userDefaults.integer(forKey: "dataCount")
        }
        set {
            guard let count = newValue else {
                return
            }
            self.userDefaults.set(count, forKey: "dataCount")
            self.userDefaults.synchronize()
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
