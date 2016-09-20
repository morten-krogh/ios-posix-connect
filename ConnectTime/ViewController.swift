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
    let useFoundation = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let label = UILabel()
        let button = UIButton()

        label.text = "Result"
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.numberOfLines = 1
        label.frame = CGRect(x: 15, y: 50, width: 400, height: 100)

        button.setTitle("Tap to connect to server", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect(x: 15, y: 250, width: 400, height: 100)
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(label)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func buttonClicked(sender: UIButton!) {

        let start = NSDate()
        
        var success = false
        
        if useFoundation {
            if connectWithCFStream() {
                success = true
            }
        }
        else {
            let rc = connect_to_server()
            
            if (rc == 0) {
                success = true
            }
        }
        
        let end = NSDate()
        
        let duration: Double = end.timeIntervalSince(start as Date)
        
        var result = ""
        
        if success == true {
            result = "Duration: \(duration)"
        }
        else {
            result = "error"
        }

        label.text = result
    }
    
    func connectWithCFStream() -> Bool {
        var readStream : Unmanaged<CFReadStream>?
        var writeStream : Unmanaged<CFWriteStream>?
        let host : CFString = NSString(string: "212.116.89.62")
        let port : UInt32 = UInt32(80)
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readStream, &writeStream)
        
        let inputStream: InputStream = readStream!.takeUnretainedValue()
        let outputStream: OutputStream = writeStream!.takeUnretainedValue()
        
        inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
        
        while(!outputStream.hasSpaceAvailable) {
            write(stream: outputStream)
            close(stream: outputStream)
            break
        }
        
        var result = ""
        
        while (!inputStream.hasBytesAvailable) {
            result = read(stream: inputStream)
            close(stream: inputStream)
            break
        }
        
        let index = result.index(result.startIndex, offsetBy: 12)
        
        if result.substring(to: index) == "HTTP/1.1 400" {
            return true
        }
        
        return false
    }
    
    func write(stream: OutputStream) {
        let getRequest = "GET http://www.amberbio.com/connect_time HTTP/1.1\r\n\r\n".data(using: String.Encoding.utf8)!
        
        _ = getRequest.withUnsafeBytes { stream.write($0, maxLength: getRequest.count) }
    }
    
    func read(stream: InputStream) -> String {
        var buffer = [UInt8](repeating: 0, count: 1000)
        let _ = stream.read(&buffer, maxLength: buffer.count)
        let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
        
        return output as! String
    }
    
    func close(stream: Stream) {
        stream.close()
        stream.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
}

