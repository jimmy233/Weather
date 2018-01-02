//
//  WebViewController.swift
//  Weather
//
//  Created by jimmy233 on 2018/1/2.
//  Copyright © 2018年 NJU. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var url:String?
    @IBOutlet weak var Web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Web.loadRequest(URLRequest(url:URL(string:url!)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
