//
//  AppLookupResults.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

struct AppLookupResults: AppLookupResponse {
    
    let resultCount: Int
    let results: [App]
    
}
