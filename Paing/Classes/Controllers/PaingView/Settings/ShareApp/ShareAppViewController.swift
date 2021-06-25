//
//  ShareAppViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 05/06/21.
//

import UIKit
import MessageUI

class ShareAppViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    var strMessageToSent = ""

    //APP Lyf Cycyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.strMessageToSent = "Instale Paing\nhttps://apps.apple.com/us/app/paing/id1572833595\nPodrás conocer gente nueva y tener citas haciendo nuevos amigos en España."
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func actionbtnShare(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.sendTextMessage(strTextMessage: self.strMessageToSent)
        case 1:
            self.sendOnMailAPP(strMessage: self.strMessageToSent)
        case 2:
            self.sendOnMailAPP(strMessage: self.strMessageToSent)
        case 3:
            self.openWhatapp(strMessage: self.strMessageToSent)
        default:
            self.openFacebook(strMessage: self.strMessageToSent)
        }
    }
    
}

//MARK:- Share App on Social platform
extension ShareAppViewController{
    //================== SEND TEXT MESSAGE ================//
    func sendTextMessage(strTextMessage:String){
        print(strTextMessage)
        let messageVC = MFMessageComposeViewController()
        messageVC.body = strTextMessage
        messageVC.recipients = [""]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
           switch (result) {
           case .cancelled:
               print("Message was cancelled")
           case .failed:
               print("Message failed")
           case .sent:
               print("Message was sent")
           default:
               return
           }
           dismiss(animated: true, completion: nil)
       }
    
    //================== SEND Gmail MESSAGE ================//
    
    func sendOnMailAPP(strMessage:String){
        // Modify following variables with your text / recipient
        let recipientEmail = ""
        let subject = "Paing App iOS"
        let body = strMessage
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
              let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
              let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
              
              let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
              let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
              let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
              
              if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                  return gmailUrl
              } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                  return outlookUrl
              } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                  return yahooMail
              } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                  return sparkUrl
              }
              
              return defaultUrl
          }
          
          func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
              controller.dismiss(animated: true)
          }
    

    //================== SEND WHATSAPP TEXT MESSAGE ================//
    
    func openWhatapp(strMessage:String){
        let message = strMessage
        let urlWhats = "whatsapp://send?text=\(message)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                        
                    })
                } else {
                    // Handle a problem
                }
            }
        }
    }
    
    //================== SEND Facebook TEXT MESSAGE ================//
 
    func openFacebook(strMessage: String) {
        
        let webURL: NSURL = NSURL(string: "https://www.facebook.com/ID")!
        let IdURL: NSURL = NSURL(string: "fb://profile/ID")!
        
        if(UIApplication.shared.canOpenURL(IdURL as URL)){
            // FB installed
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        } else {
            // FB is not installed, open in safari
            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
        }
        
    }
    
}
