//
//  DeliveryAPIV2.swift
//  JWPlatform
//
//  Created by Kyle Ishie on 9/9/18.
//

import Foundation
import RESTClient
import JWT


public class DeliveryAPIV2 : RESTClient<DeliveryAPIV2.Error> {
    
    public struct Error : Swift.Error, Codable {
        public let message : String
    }
    
    public struct Response<T : Codable & Resource> : Codable, Resource, Retrievable {
        
        public let playlist : Playlist
        public let description : String
        public let links : [String : URL]?
        public let title : String
        public let feed_instance_id : UUID
        public let feedid : String?
        public let kind : String
        
        public static var path : String {
            return T.path
        }
    }
    
    
    private let secret: String
    private let isProtected: Bool
    private let protectionExpiration: TimeInterval
    
    public init(secret: String, isProtected: Bool = false, protectionExpiration: TimeInterval = 60) {
        self.secret = secret
        self.isProtected = isProtected
        self.protectionExpiration = protectionExpiration
        
        super.init(url: URL(string: "https://cdn.jwplayer.com/v2/")!,
                   sessionConfig: URLSessionConfiguration.default)
        
        /// Setup JSON Encoder
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        self.encoder(jsonEncoder, for: "application/json; charset=utf-8")
        
        /// Setup JSON Decoder
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        self.decoder(jsonDecoder, for: "application/json; charset=utf-8")
    }
    
}


//MARK: Media Specific
extension DeliveryAPIV2 {
    
    public enum MediaFormat : String {
        case json
        case mrss
        case legacyrss
    }
    
    public enum MediaQueryParameter {
        case format(MediaFormat)
        case poster_width(Int)
        case recommendations_playlist_id(String)
        case sources([String])
        case default_source_fallback(Bool)
    }
    
    public func getMedia(_ mediaId: String, query: [MediaQueryParameter] = [], completion: @escaping ((Result<Response<Media>, Error>) -> Void)) {
        
        var dic = [String : String]()
        query.forEach({ queryParameter in
            switch queryParameter {
            case let .format(format):
                dic["format"] = format.rawValue
            case let .poster_width(width):
                dic["poster_width"] = "\(width)"
            case let .recommendations_playlist_id(id):
                dic["recommendations_playlist_id"] = id
            case let .sources(sources):
                dic["sources"] = sources.joined(separator: ",")
            case let .default_source_fallback(fallback):
                dic["default_source_fallback"] = "\(fallback)"
            }
        })
        
        if isProtected {
            
            var claims = ClaimSet(claims: dic)
            claims["resource"] = "/v2/media/" + mediaId
            claims["exp"] = Date().addingTimeInterval(protectionExpiration).timeIntervalSince1970
            
            let jwt = JWT.encode(claims: claims, algorithm: .hs256(secret.data(using: .utf8)!))
            dic["token"] = jwt
        }
        
        retrieve(Response<Media>.self, id: mediaId, query: dic, completionHandler: completion).resume()
    }
    
}

//MARK: Playlist Specific
extension DeliveryAPIV2 {
    
    public func getPlaylist(_ playlistId: String, query: [MediaQueryParameter] = [], completion: @escaping ((Result<Response<Playlist>, Error>) -> Void)) {
        
        var dic = [String : String]()
        query.forEach({ queryParameter in
            switch queryParameter {
            case let .format(format):
                dic["format"] = format.rawValue
            case let .poster_width(width):
                dic["poster_width"] = "\(width)"
            case let .recommendations_playlist_id(id):
                dic["recommendations_playlist_id"] = id
            case let .sources(sources):
                dic["sources"] = sources.joined(separator: ",")
            case let .default_source_fallback(fallback):
                dic["default_source_fallback"] = "\(fallback)"
            }
        })
        
        if isProtected {
            
            var claims = ClaimSet(claims: dic)
            claims["resource"] = "/v2/playlists/" + playlistId
            claims["exp"] = Date().addingTimeInterval(protectionExpiration).timeIntervalSince1970
            let jwt = JWT.encode(claims: claims, algorithm: .hs256(secret.data(using: .utf8)!))
            dic["token"] = jwt
        }
        
        retrieve(Response<Playlist>.self, id: playlistId, query: dic, completionHandler: completion).resume()
    }
    
}

