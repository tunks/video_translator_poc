//
//  Language.swift
//  SpeechtoText
//
//  Created by Ebrima Tunkara on 8/16/18.
//  Copyright © 2018 Tunks dev. All rights reserved.
//

import AVFoundation
import LanguageTranslatorV3


class Language{
    static func detectedLangauge<T: StringProtocol>(_ forString: T) -> String? {
        guard let languageCode = NSLinguisticTagger.dominantLanguage(for: String(forString)) else {
            return nil
        }
        
        return languageCode
    }
}


protocol Translator{
    func translate(text: String, source: String, target: String ,
                   completion:  @escaping (_ text: String?) -> Void)
    
    func pause(pause: Bool?)
}

class WatsonLanguageTranslator : Translator {
    var translator : LanguageTranslator!
    var handler: WastonTranslateHandler?
    private let failure = { (error: Error) in print(error) }
    private var modelId = { (source: String, target: String ) -> String in return source+"-"+target}
    
    init(){
        translator = LanguageTranslator(version: Credentials.TranslateVersion,
                                        apiKey:  Credentials.TranslateApikey);
        translator.serviceURL = Credentials.TranslateUrl
        
        self.handler = WastonTranslateHandler()
    }
    
    func translate(text: String, source: String, target: String, completion: @escaping (_ text: String?) -> Void){
        ///source: "en", target: "es"
        //let modelId = ModelId(source,target)
        self.translator.translate(text: [text], source: source, target: target) { (response,error) in
            self.handler?.handle(result: (response?.result)!, language: target,completion: completion)
        }
    }
    
    func pause(pause: Bool?) {
        self.handler?.textToSpeech.paused = pause!
    }
    
}


class WastonTranslateHandler{
    var textToSpeech =  TextSpeech()
    
    func handle(result: TranslationResult, language: String?, completion: (_ text: String?) -> Void) {
         for translation in result.translations {
            let output = translation.translationOutput
            completion(_: output)
            textToSpeech.speech(text: output, language: language)
         }
    }
    
}

class TextSpeech{
    let synthesizer = AVSpeechSynthesizer()
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var voiceToUse: AVSpeechSynthesisVoice?
    var paused: Bool = false{
        didSet{
            if paused {
                self.pause()
            }
        }
    }

 
    func speech(text: String, language: String?){
        if !paused{
          let utterance = AVSpeechUtterance(string: text)
           utterance.voice = AVSpeechSynthesisVoice(language: language)
           utterance.rate = 0.5
           utterance.pitchMultiplier = 0.85
           utterance.volume = 0.8
           synthesizer.continueSpeaking()
           synthesizer.speak(utterance)
        }
    }
    private func pause(){
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
