//
//  GithubRequest.swift
//  Github-contribution-OSX
//
//  Created by Remi Robert on 08/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class GithubRequest {
    private func parse(html: NSString) -> [Contribution] {
        do {
            let pattern = "(fill=\")(#[^\"]{6})(\" data-count=\")([^\"]{1,})(\" data-date=\")([^\"]{10})(\"/>)"
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: html as String, range: NSRange(location: 0, length: html.length))
            
            var contributions = [Contribution]()
            for result in results {
                if result.numberOfRanges > 6 {
                    let color = html.substring(with: result.rangeAt(2))
                    let dataCount = Int(html.substring(with: result.rangeAt(4))) ?? 0
                    let date = html.substring(with: result.rangeAt(6))
                    let contribution = Contribution(color: color, dataCount: dataCount, date: date)
                    contributions.append(contribution)
                }
            }
            return contributions
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    public func contributions(username : String, _ completion: @escaping ([Contribution]?) -> Void) {
        let url = URLRequest(url: URL(string: "https://github.com/users/\(username)/contributions")!)
        let request = URLSession.shared.dataTask(with: url) { (data: Data?, _, error: Error?) in
            guard let data = data else {
                return
            }
            guard let stringData = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                completion(nil)
                return
            }
            completion(self.parse(html: stringData))
        }
        request.resume()
    }
    
    public init() {}
}
