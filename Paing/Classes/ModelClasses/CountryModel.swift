//
//  CountryModel.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 28/05/21.
//

import UIKit

class CountryModel: NSObject {

    var strCountryID    :String = ""
    var strCountryName :String = ""
    
    init(dict : [String:Any]) {
        
        if let country_id = dict["country_id"] as? String{
            self.strCountryID = country_id
        }else if let country_id = dict["country_id"] as? Int{
            self.strCountryID = "\(country_id)"
        }
        
        if let country_name = dict["country_name"] as? String{
            self.strCountryName = country_name
        }
    }
    
}

//MARK:- State Model
class StateModel: NSObject {

    var strCountryID    :String = ""
    var strStateID    :String = ""
    var strStateName :String = ""
    
    init(dict : [String:Any]) {
        
        if let country_id = dict["country_id"] as? String{
            self.strCountryID = country_id
        }else if let country_id = dict["country_id"] as? Int{
            self.strCountryID = "\(country_id)"
        }
        
        if let state_id = dict["state_id"] as? String{
            self.strStateID = state_id
        }else if let state_id = dict["state_id"] as? Int{
            self.strStateID = "\(state_id)"
        }
        
        if let state_name = dict["state_name"] as? String{
            self.strStateName = state_name
        }
    }
    
}


//MARK:- City Model
class CityModel: NSObject {

    var strCityID    :String = ""
    var strStateID    :String = ""
    var strCityName :String = ""
    
    init(dict : [String:Any]) {
        
        if let city_id = dict["city_id"] as? String{
            self.strCityID = city_id
        }else if let city_id = dict["city_id"] as? Int{
            self.strCityID = "\(city_id)"
        }
        
        if let state_id = dict["state_id"] as? String{
            self.strStateID = state_id
        }else if let state_id = dict["state_id"] as? Int{
            self.strStateID = "\(state_id)"
        }
        
        if let city_name = dict["city_name"] as? String{
            self.strCityName = city_name
        }
    }
    
}
