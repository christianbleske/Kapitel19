//
//  DetailViewController.swift
//  SpotlightBsp
//
//  Created by Christian Bleske on 01.03.16.
//  Copyright © 2016 Christian Bleske. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet var laUrheber: UILabel!

    var detailItem: Zitat? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.text
            }
            
            if let label2 = self.laUrheber {
                label2.text = detail.urheber
            }
            
           /* print (detail.text)
            print (detail.urheber)*/
            
            let activity = NSUserActivity(activityType: "de.beispiel.spotlight.zitat")
            activity.userInfo = ["text": detailItem!.text, "urheber": detailItem!.urheber]
            activity.title = "Zitat"
            var keywords = detailItem!.text.components(separatedBy: " ")
            keywords.append((detailItem?.urheber)!)
            activity.keywords = Set(keywords)
            activity.isEligibleForHandoff = false
            activity.isEligibleForSearch = true
            activity.isEligibleForPublicIndexing = true
            
            activity.becomeCurrent()


        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

