//
//  Track.swift
//  JWPlatform
//
//  Created by Kyle Ishie on 9/9/18.
//

import Foundation

public enum Track {
    case captions(file: URL, label: String, isDefault: Bool)
    case thumbnails(file: URL)
    
    private enum CodingKeys : String, CodingKey {
        case kind
        case file
        case label
        case `default`
    }
    
    private enum TrackKind : String, Codable {
        case captions = "captions"
        case thumbnails = "thumbnails"
    }
    
}

extension Track : Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .captions(file, label, isDefault):
            try container.encode(TrackKind.captions, forKey: .kind)
            try container.encode(file, forKey: .file)
            try container.encode(label, forKey: .label)
            try container.encode(isDefault, forKey: .default)
            
        case let .thumbnails(file):
            try container.encode(TrackKind.thumbnails, forKey: .kind)
            try container.encode(file, forKey: .file)
        }
    }
    
}

extension Track : Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(TrackKind.self, forKey: .kind)
        let file = try container.decode(URL.self, forKey: .file)
        
        switch kind {
        case .captions:
            let label = try container.decode(String.self, forKey: .label)
            let isDefault = try container.decodeIfPresent(Bool.self, forKey: .default) ?? false
            self = .captions(file: file, label: label, isDefault: isDefault)
            
        case .thumbnails:
            self = .thumbnails(file: file)
        }
    }
    
}
