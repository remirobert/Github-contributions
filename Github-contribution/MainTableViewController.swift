//
//  MainTableViewController.swift
//  Github-contribution
//
//  Created by Remi Robert on 05/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    private let request = GithubRequest()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var labelContributions: UILabel!
    @IBOutlet weak var viewColorContribution: UIView!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    func getContributions(username: String) {
        self.request.contributions(username: username) { contributions in
            guard let contributions = contributions else {
                return
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.labelError.isHidden = true
                let image = ImageContribution.generate(withContributions: contributions)
                self.imageView.image = image
                ApplicationDatas.sharedInstance.imageContribution = image
                
                guard let todayContribution = contributions.last else {
                    return
                }
                
                let todayColor = UIColor.initFrom(hex: todayContribution.color)
                let todayCount = todayContribution.dataCount
                
                WatchSessionManager.default.save(data: ["username": username, "dataCount": todayCount, "color": todayContribution.color])
                ApplicationDatas.sharedInstance.todayColor = todayContribution.color
                ApplicationDatas.sharedInstance.todayDataCount = todayCount
                
                self.viewColorContribution.backgroundColor = todayColor
                if todayCount == 0 {
                    self.labelContributions.text = "No contributions"
                }
                else {
                    self.labelContributions.text = "\(todayContribution.dataCount) contributions"
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
        guard let username = ApplicationDatas.sharedInstance.username else {
            return
        }
        self.getContributions(username: username)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldUsername.delegate = self
        guard let username = ApplicationDatas.sharedInstance.username else {
            self.labelError.isHidden = false
            self.textfieldUsername.becomeFirstResponder()
            return
        }
        self.labelError.isHidden = true
        self.imageView.image = nil
        self.viewColorContribution.backgroundColor = UIColor.clear
        self.labelContributions.text = nil
        
        if let image = ApplicationDatas.sharedInstance.imageContribution {
            self.imageView.image = image
        }
        if let dataCount = ApplicationDatas.sharedInstance.todayDataCount,
            let color = ApplicationDatas.sharedInstance.todayColor {
            self.viewColorContribution.backgroundColor = UIColor.initFrom(hex: color)
            if dataCount == 0 {
                self.labelContributions.text = "No contributions"
            }
            else {
                self.labelContributions.text = "\(dataCount) contributions"
            }
        }
        self.textfieldUsername.text = username
        self.getContributions(username: username)
    }
}

extension MainTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            self.view.endEditing(true)
            guard let username = self.textfieldUsername.text else {
                return false
            }
            let trimUsername = username.replacingOccurrences(of: " ", with: "")
            self.textfieldUsername.text = trimUsername
            ApplicationDatas.sharedInstance.username = trimUsername
            self.getContributions(username: trimUsername)
            return false
        }
        return true
    }
}

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            let heightElement = UIScreen.main.bounds.size.width / 53 * 7
            return heightElement
        }
        return 44
    }
}
