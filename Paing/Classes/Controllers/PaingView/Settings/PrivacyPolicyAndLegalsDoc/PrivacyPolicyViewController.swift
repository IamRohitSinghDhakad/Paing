//
//  PrivacyPolicyViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 29/05/21.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var vwWebkit: WKWebView!
    
    var strType = ""
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        vwWebkit.load(request as URLRequest)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeader.text = strType
        
        switch strType {
        case "Contáctenos":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Contact")
        case "Privacidad":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Privacy")
        case "Aviso legal":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Legal%20warning")
        case "Denunciar perfil":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Report%20profile")
        case "LegalWarning":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Legal%20warning")
        case "Condiciones de uso":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Terms%20of%20use")
        case "Cookies":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Cookies")
        case "Ayuda":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Help")
        case "Configuración":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/setting")
        case "Política de privacidad":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/privacy%20policy")
        case "Sugerencias":
            self.loadUrl(strUrl: "http://ambitious.in.net/Shubham/paing/index.php/api/page/Suggestions")
        default:
            break
        }
        
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
}


extension PrivacyPolicyViewController: WKNavigationDelegate{
    
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
