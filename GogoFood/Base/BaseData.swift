//
//  BaseData.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 11/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseData: Mappable {
    var id = 0
    private var created_at : String?
    var updated_at : String?
    var __v : Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        __v <- map["__v"]
    }
    
    func isReadyToSave() -> String {
        //preconditionFailure("overrider it")
        return ""
    }
    
    func getCombineString() -> String {
        return  id.description
    }
    
    func update(_ data :BaseData , isForce :Bool = false){
        id = data.id != 0 || isForce ? data.id : id
    }
    
    func getCreatedTime() -> String {
        return self.created_at ?? ""
    }
    
    
}


extension BaseData : Hashable {
    
    var hashValue: Int {
        return getCombineString().hashValue
    }
    
}

extension BaseData : Equatable {}

func == (lhs: BaseData, rhs: BaseData) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}


class BaseObjectResponse<T: BaseData>: BaseData {
    
    var message: String = ""
    var success: Bool = false
    var data: T?
    
    override func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
        data <- map["data"]
    }
    
}
