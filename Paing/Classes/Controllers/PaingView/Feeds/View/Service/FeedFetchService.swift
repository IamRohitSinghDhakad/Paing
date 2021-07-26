//
//  FeedFetcherService.swift
//  StreamLabsAssignment
//
//  Created by Jude on 16/02/2019.
//  Copyright © 2019 streamlabs. All rights reserved.
//

import Foundation

protocol FeedFetchDelegate: AnyObject {
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds feeds: [BlogListModel], withError error: Error?)
}

protocol FeedFetchProtocol: AnyObject {
    var delegate: FeedFetchDelegate? { get set }
    func fetchFeeds()
}

class FeedFetcher: FeedFetchProtocol {
    
    func fetchFeeds() {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
          //  objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["my_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getVideos, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                 //   self.arrBlogList.removeAll()
                   var arrBlogList = [BlogListModel]()
                    for dictdata in arrData{
                        
                        let obj = BlogListModel.init(dict: dictdata)
                        if objAppShareData.UserDetail.strUserId == obj.strBlogUserID{
                            arrBlogList.append(obj)
                        }else{
                            //Do Nothing
                        }
                        
                    }
                    
                    self.delegate?.feedFetchService(self, didFetchFeeds: arrBlogList, withError: nil)
                    

                    
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                  //  self.tblBLogs.displayBackgroundText(text: "Aún no publicas ningún blog")
                }else{
                   // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
 //   fileprivate let networking: ConnectionProtocol.Type
    weak var delegate: FeedFetchDelegate?
    
//    init(networking: ConnectionProtocol.Type = Connection.self) {
//        self.networking = networking
//    }
    
    
//    func fetchFeeds() {
//        let param = ["my_id":"49"]as [String:AnyObject]
//        guard let request = HTTPRequest(url: URL(string: BASE_URL),body: param) else { return }
//        networking.makeRequest(request, errorHandler: { [weak self] error in
//            guard let serviceSelf = self else {
//                return
//            }
//            serviceSelf.fetchFeedFailed(withError: error)
//        }) { [weak self] data, _ in
//            guard let serviceSelf = self else {
//                return
//            }
//            print(data)
//            serviceSelf.fetchFeedSuccess(withData: data)
//        }
//    }
    

    
    
    
    
    fileprivate func fetchFeedFailed(withError error: Error) {
        self.delegate?.feedFetchService(self, didFetchFeeds: [], withError: error)
    }
    
    
    fileprivate func fetchFeedSuccess(withData data: Data) {
//        var feeds: [BlogListModel]
//        do {
//            feeds = try JSONDecoder().decode([BlogListModel].self, from: data)
//        } catch {
//
//            feeds = []
//        }
//        self.delegate?.feedFetchService(self, didFetchFeeds: feeds, withError: nil)
    }
}

