//
//  ViewController_InfoPage.swift
//  ObellaBe
//
//  Created by David Lerohl on 7/23/15.
//  Copyright © 2015 David Lerohl. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var viewWeb: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add WebView
        let url = NSURL(string: "http://www.obellabe.com");
        let requestObj = NSURLRequest(URL: url!);
        viewWeb.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // IB Actions
    @IBAction func closeInfo(){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
}