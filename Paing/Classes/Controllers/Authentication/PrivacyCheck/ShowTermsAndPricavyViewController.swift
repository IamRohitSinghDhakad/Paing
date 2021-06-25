//
//  ShowTermsAndPricavyViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 14/06/21.
//

import UIKit
import WebKit

class ShowTermsAndPricavyViewController: UIViewController {
    
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var lblTitle: UILabel!
    
    var strType = ""
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        webVw.load(request as URLRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = strType
        
        switch strType {
        case "Política de privacidad":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/privacy%20policy")
        case "Condiciones de uso":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Terms%20of%20use")
        case "Cookies":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Cookies")
     
        default:
            break
        }
        
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    

}



extension ShowTermsAndPricavyViewController: WKNavigationDelegate{
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
