//
//  Playlist.swift
//  JWPlatform
//
//  Created by Kyle Ishie on 9/9/18.
//

import Foundation
import RESTClient

public typealias Playlist = [Media]

extension Array : Resource where Element == Media {
    
    public static var path : String {
        return "playlists"
    }
    
}
