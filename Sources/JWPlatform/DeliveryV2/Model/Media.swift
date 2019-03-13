//
//  Media.swift
//  JWPlatform
//
//  Created by Kyle Ishie on 9/9/18.
//

import Foundation
import RESTClient

public struct Media : Codable {
    
    public let description: String
    public let duration : Int
    public let image : URL
    public let link : URL
    public let mediaid : String
    public let pubdate : Date
    public let sources : [Source]
    public let tags : String?
    public let title : String
    public let tracks : [Track]
    public let variations : [String : String]?
    
}


extension Media : Resource {
    
    public static var path: String {
        return "media"
    }
    
}
extension Media : Retrievable {}



