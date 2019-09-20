//
//  WebController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 20/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {
    @IBOutlet weak var webbrowser: WKWebView!
    @IBOutlet weak var webview: UIView!
    
    var urlDefault: String = "https://bill.web.id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let url = URL(string: urlDefault)!
        webbrowser.load(URLRequest(url: url))
        
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webbrowser, action: #selector(webbrowser.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
