//
//  Source.swift
//  JWPlatform
//
//  Created by Kyle Ishie on 9/9/18.
//

import Foundation

public enum Source {
    case mpegurl(file: URL)
    case mp4Video(file: URL, height: Int, width: Int, label: String)
    case mp4Audio(file: URL, label: String)
    
    private enum CodingKeys : String, CodingKey{
        case type
        case file
        case label
        case height
        case width
    }
    
    private enum SourceType : String, Codable {
        case mpegurl = "application/vnd.apple.mpegurl"
        case mp4Video = "video/mp4"
        case mp4Audio = "audio/mp4"
    }
    
}


extension Source : Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .mpegurl(file):
            try container.encode(SourceType.mpegurl, forKey: .type)
            try container.encode(file, forKey: .file)
            
        case let .mp4Video(file, height, width, label):
            try container.encode(SourceType.mp4Video, forKey: .type)
            try container.encode(file, forKey: .file)
            try container.encode(height, forKey: .height)
            try container.encode(width, forKey: .width)
            try container.encode(label, forKey: .label)

        case let .mp4Audio(file, label):
            try container.encode(SourceType.mp4Audio, forKey: .type)
            try container.encode(file, forKey: .file)
        }
    }
    
}

extension Source : Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(SourceType.self, forKey: .type)
        let file = try container.decode(URL.self, forKey: .file)

        switch type {
        case .mpegurl:
            self = .mpegurl(file: file)
            
        case .mp4Video:
            let height = try container.decode(Int.self, forKey: .height)
            let width = try container.decode(Int.self, forKey: .width)
            let label = try container.decode(String.self, forKey: .label)
            self = .mp4Video(file: file, height: height, width: width, label: label)
            
        case .mp4Audio:
            let label = try container.decode(String.self, forKey: .label)
            self = .mp4Audio(file: file, label: label)
        }
    }
    
}
