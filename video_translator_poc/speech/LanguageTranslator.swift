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
    func translate(text: String, source: String, target: String )
}

class WatsonLanguageTranslator : Translator {
    var translator : LanguageTranslator!
    var handler: WastonTranslateHandler?
    private let failure = { (error: Error) in print(error) }
    private var ModelId = { (source: String, target: String ) -> String in return source+"-"+target}
    
    init(){
        translator = LanguageTranslator(version: Credentials.TranslateVersion,
                                        apiKey:  Credentials.TranslateApikey);
        translator.serviceURL = Credentials.TranslateUrl
        
        self.handler = WastonTranslateHandler()
    }
    
    func translate(text: String, source: String, target: String){
       // let  request = TranslateRequest(text: [text], modelID: modelId(source, target),
         //                               source: source, target: target )
        ///source: "en", target: "es"
        //let modelId = ModelId(source,target)
        self.translator.translate(text: [text], source: source, target: target) { (response,error) in
            self.handler?.handle(result: (response?.result)!, language: target)
        }
        /*
        self.translator.translate(mo failure: failure, success: { (translation) -> Void in
            self.handler?.handle(result: translation, language: target)
        })
 */
    }
    
}


class WastonTranslateHandler{
    var textToSpeech =  TextSpeech()
    
    func handle(result: TranslationResult, language: String?) {
         print(result)
        
         for translation in result.translations{
            textToSpeech.speech(text: translation.translationOutput, language: language)
         }
    }
    
}

class TextSpeech{
    let synthesizer = AVSpeechSynthesizer()
    let voices = AVSpeechSynthesisVoice.speechVoices()
    var voiceToUse: AVSpeechSynthesisVoice?

 
    func speech(text: String, language: String?){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.85
        utterance.volume = 0.8
        synthesizer.continueSpeaking()
        synthesizer.speak(utterance)
    }
    func stop(){
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
