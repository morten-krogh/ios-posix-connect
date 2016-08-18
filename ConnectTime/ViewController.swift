//
//  ViewController.swift
//  ConnectTime
//
//  Created by Morten Krogh on 17/08/16.
//  Copyright © 2016 Amber Biosicences. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let label = UILabel()
        let button = UIButton()

        label.text = "Result"
        label.textColor = UIColor.redColor()
        label.textAlignment = .Center
        label.numberOfLines = 1
        label.frame = CGRectMake(15, 50, 400, 100)

        button.setTitle("Tap to connect to server", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRectMake(15, 250, 400, 100)
        button.addTarget(self, action: #selector(self.repeated_connect), forControlEvents: .TouchUpInside)
        self.view.addSubview(label)
        self.view.addSubview(button)

//        repeated_connect();

    }

    func repeated_connect() {
        let start = NSDate()
        let rc = connect_to_server();
        let end = NSDate()
        let duration: Double = end.timeIntervalSinceDate(start)

        var result = ""
        if (rc == 0) {
            result = "Duration: \(duration)"
        } else {
            result = "error"
        }
        label.text = result

        if (rc == 0) {
            let delay = 1 as Double // time in seconds
            NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(repeated_connect), userInfo: nil, repeats: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttonClicked(sender: UIButton!) {

        let start = NSDate()

        let rc = connect_to_server();

        let end = NSDate()

        let duration: Double = end.timeIntervalSinceDate(start)

        var result = ""

        if (rc == 0) {
            result = "Duration: \(duration)"
        } else {
            result = "error"
        }

        label.text = result
    }

}

