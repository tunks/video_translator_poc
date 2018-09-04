//
//  DataStore.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/3/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

protocol DataStore {
    func set(key: String, value: VideoItem)
    func get(key: String ) -> VideoItem?
    func remove(key: String)
    func keys()->[String]
    func values()->[VideoItem]
}

struct VideoItem: Equatable{
    var title: String
    var url: String
    var language: String? = "English"
    
    init(title: String, url: String){
        self.title = title
        self.url = url
    }
    
    init(title: String, url: String, language: String?){
        self.title = title
        self.url = url
        self.language  = language
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case language
    }
}

extension VideoItem:  Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.url = try values.decode(String.self, forKey: .url)
        self.language = try values.decode(String.self, forKey: .language)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(language, forKey: .language)
    }
}

class VideoDataStore: DataStore{
    static let WordLimit = "word_limit"
    private let KeyIndex = "video_key_indexes"
    private let encoder =  JSONEncoder()
    private let decoder = JSONDecoder()
    
    static let shared = VideoDataStore()

    func set(key: String, value: VideoItem) {
        try? UserDefaults.standard.set(value.encode(), forKey: key)
        self.addKeyIndex(key: key)
        //print("Saved: \(key)")
    }
    
    func set(key: String, value: String){
         UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(key: String) -> VideoItem? {
        guard let data = UserDefaults.standard.object(forKey: key) else { return nil }
        let value: VideoItem = try! VideoItem.decode(from: data as! Data)
        return value
    }
    
    func get(key: String) ->String?{
          return UserDefaults.standard.string(forKey: key)
    }
    
    func keys() -> [String] {
        return self.keyIndexes()
    }
    
    func remove(key: String) {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: key)
            self.removeKeyIndex(key)
            //print("removed: \(key)")
        }
    }
    
    func values() -> [VideoItem] {
        let keys = keyIndexes()
        //print("keys \(keys)")
        var values: [VideoItem] = []
        for k in keys{
            //print("1. key: \(k)")
            let value: VideoItem = self.get(key: k)!
            //print("2. value: \(value)")
            values.append(value)
        }
    
        return values
    }
    
    func clear(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}

extension VideoDataStore{
    private func addKeyIndex(key: String){
        let contains:Bool = keyIndexes().contains(where: { $0 == key })
        if !contains{
            var keys = keyIndexes()
            keys.append(key)
            UserDefaults.standard.set(keys, forKey: KeyIndex)
        }
    }
    
    private func keyIndexes()->[String]{
        guard let keys = UserDefaults.standard.stringArray(forKey: KeyIndex) else { return [] }
        return keys
    }
    
    private func removeKeyIndex(_ key: String){
        var keys = keyIndexes()
        if let index = Int(key){
           keys.remove(at: index)
        }
    }
}
