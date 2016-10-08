//
//  ContributionViewModel.swift
//  Github-contribution
//
//  Created by Remi Robert on 06/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import RxSwift

class ContributionViewModel {
    
//    private  let request = RequestGithub()
//    var imageContribution = Variable<UIImage?>(nil)
//    var imageDayContribution = Variable<UIColor>(UIColor.clear)
//    var labelDayContribution = Variable<String?>(nil)
//    
//    func getContributions() {
//        self.imageContribution.value = nil
//        self.imageDayContribution.value = UIColor.clear
//        self.labelDayContribution.value = nil
//        
//        self.request.getContribution { contributions in
//            guard let contributions = contributions else {
//                return
//            }
//            self.imageContribution.value = self.request.generateImage(contributions)
//            guard let todayContribution = contributions.last else {
//                return
//            }
//            
//            self.imageDayContribution.value = UIColor.initFrom(hex: todayContribution.color)
//            if todayContribution.dataCount == 0 {
//                self.labelDayContribution.value = "No contributions"
//            }
//            else {
//                self.labelDayContribution.value = "\(todayContribution.dataCount) contributions"
//            }
//        }
//    }
}
