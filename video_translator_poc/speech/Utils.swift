//
//  Utils.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/25/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import AVFoundation

class Utils{
   private static let formatter = DateFormatter()
   static func printLog(log: Any?) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print(formatter.string(from: NSDate() as Date), terminator: "")
        if log == nil {
            print("nil")
        }
        else {
            print(log!)
        }
    }
}

extension AVAudioPCMBuffer {
    func toData() -> Data {
        let channels = UnsafeBufferPointer(start: self.int16ChannelData, count: 1)
        let ch0Data = Data(bytes: UnsafeMutablePointer(channels[0]),
                           count: Int(frameCapacity * format.streamDescription.pointee.mBytesPerFrame))
        return ch0Data
    }
}


extension String {
    /**
     * Get match ratio
     */
    func characterPrefixRatio(of pattern: String) -> (Int?,Int?)  {
        let prefix = self.commonPrefix(with: pattern)
        //self.
        return (prefix.count, prefix.count*100/pattern.count);
    }
    
    func wordPrefixRatio(of pattern: String) -> Int? {
        var words = self.components(separatedBy: CharacterSet.whitespaces)
        
        
        let prefix = self.commonPrefix(with: pattern)
        //self.
        return prefix.count*100/pattern.count;
    }
    /*
     func trimmingTrailingSpaces() -> String {
     var t = self
     while t.hasSuffix(" ") {
     t = "" + t.dropLast()
     }
     return t
     }
     
     mutating func trimmedTrailingSpaces() {
     self = self.trimmingTrailingSpaces()
     }
     */
}



