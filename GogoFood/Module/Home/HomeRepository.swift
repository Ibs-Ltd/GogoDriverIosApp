//
//  HomeRepository.swift
//  GogoFood
//
//  Created by MAC on 01/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import Foundation
import Alamofire
import SocketIO


class HomeRepository: BaseRepository {
    func notificationListAPI(onComplition: @escaping responseObject<NotificationListRootData>) {
        showLoader(nil)
        Alamofire.request(ServerUrl.notificationsURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.header).responseString { (data) in
            
            let dict = try! JSONSerialization.jsonObject(with: data.data!, options: []) as! NSDictionary
            //print(dict)
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                let str = String(data: data, encoding: .utf8) {
                //print(str)
            }

            if let d: NotificationListRootData = self.getDataFrom(data) {
                onComplition(d)
            }
        }
    }
}
