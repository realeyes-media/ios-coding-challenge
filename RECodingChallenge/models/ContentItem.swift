//
//  ContentItem.swift
//  RECodingChallenge
//
//  Created by John Gainfort on 10/11/18.
//  Copyright © 2018 RealEyes Media, LLC. All rights reserved.
//

import Foundation

struct ContentItem {
    let title: String
    let source: String
}

extension ContentItem {
    
    init(json: [String: String]?) {
        let json = json ?? [String: String]()
        
        self.title = json["title"] ?? ""
        self.source = json["source"] ?? ""
    }
    
    var url: URL? {
        get {
            return URL(string: source)
        }
    }
    
}

extension ContentItem: Equatable {
    
}
