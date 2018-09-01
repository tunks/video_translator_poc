//
//  Utils.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/25/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import AVFoundation

class Utils{
   public static let LabelTextNotification  = NSNotification.Name("LABEL_TEXT")
   public static let LanguageNotification =  Notification.Name("SELECTED_LANGUAGE")
   public static let TranslateNotification =   Notification.Name("TRANSLATE")

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
    
    static func position(start: Int = 0, isFinal: Bool = false, wordMin: Int = 3, of pattern: String) -> (Int, String)? {
        var text = pattern.substring(from: start, to: pattern.count)
                          .trimmingCharacters(in: CharacterSet.whitespaces)
        //do not strip the last word if text is not final
        if !isFinal{
            var words = text.components(separatedBy: CharacterSet.whitespaces)
            var num = 0
            num = words.count > 1 ? 2: 0
            words.removeLast(num)
            if words.count >= wordMin {
               text = words.joined(separator:  " ")
            }
            else {
                text = ""
            }
        
        }
        //print("word text : \(text)")
        let position = text.count > 0 ? start + text.count + 1: start
        return (position, text)
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
    
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}



