//
//  SpeechToText.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/23/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//
//
import AVFoundation
import Speech
import MediaToolbox
import SpeechToTextV1

protocol PlayerTranslatorDelegate {
    func connectPlayer( player: AVPlayer?, itemUrl: URL?);
    /**
     Disconnet current player
     */
    func disconnect();
}

class SpeechProcessor: NSObject, PlayerTranslatorDelegate{
    private static let ContentType = "audio/l16;rate=16000;channels=2"
    private var isPlaying: Bool = false
    private let audioEngine = AVAudioEngine()
    private var parameterArray: [AVAudioMixInputParameters] = []
    private var audioMix = AVMutableAudioMix()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var tap: MYAudioTapProcessor?
    private var dataConverter: AudioDataConverter?
    private var session: SpeechToTextSession!
    private var settings: RecognitionSettings!
    private var resultHandler = SpeechTextResultHandler()
    var languageTranslator: Translator?
    var speechToText: SpeechToText!
    var isSessionStarted = false
    var isStreaming = false
    var targetLanguage: String?{
        didSet{
            self.resultHandler.targetedLanguage = targetLanguage
            print("set targeted language")
        }
    }
    
    deinit {
        if session != nil{
           disconnect()
        }
        print("speech session terminated")
    }
    func connectPlayer( player: AVPlayer?, itemUrl: URL?){
        self.player = player
        let urlAsset = AVURLAsset(url: itemUrl!)
        let audioTrack = urlAsset.tracks(withMediaType: AVMediaType.audio).first
        setupAssetTrack(audioTrack: audioTrack!)
        setupWatsonSpeechRecognizer()
    }
    
    private func setupAssetTrack(audioTrack: AVAssetTrack){
         let desc: CMAudioFormatDescription = audioTrack.formatDescriptions[0] as! CMAudioFormatDescription
         self.dataConverter = AudioDataConverter(fmt: AVAudioFormat(cmAudioFormatDescription: desc))
         tap = MYAudioTapProcessor(audioAssetTrack: audioTrack)
         tap?.delegate = self
         player?.currentItem?.audioMix = tap?.audioMix
    }
    
    func disconnect() {
        if(session != nil){
          self.session.stopRequest()
          self.session.disconnect()
          self.session = nil
          self.tap = nil
        }
    }
}

extension  SpeechProcessor{
    private func setupWatsonSpeechRecognizer(){
        session = SpeechToTextSession(
            apiKey: Credentials.SpeechApikey
        )
        session.websocketsURL = Credentials.SpeechWssUrl
        resultHandler.delegate = self
        // define recognition session callbacks
        session.onConnect = { print("connected") }
        session.onDisconnect = { print("disconnected") }
        session.onError = { error in print(error) }
        session.onResults = {
            results in
            var accumulator = SpeechRecognitionResultsAccumulator()
            accumulator.add(results: results)
            if((results.results?.count)! > 0){
                let result = results.results![0]
                if result.finalResults{
                    let transcript = accumulator.bestTranscript
                    self.resultHandler.handle(text: transcript)
                 }
            }
        }
        
        // define recognition settings
        settings = RecognitionSettings(contentType: SpeechProcessor.ContentType)
        settings.interimResults = true
        settings.inactivityTimeout = -1
        isSessionStarted = true
    }
    
    func toggleSession(paused: Bool){
        if isSessionStarted {
            if paused{
               session.stopRequest()
               session.disconnect()
                print("STT disconnected")
            }
            else{
               print("STT connected")
               session.connect()
               session.startRequest(settings: settings)
            }
            isStreaming = paused
        }
    }
}


extension SpeechProcessor : MYAudioTabProcessorDelegate {
    // getting audio buffer back from the tap and feeding into speech recognizer
    func audioTabProcessor(_ audioTabProcessor: MYAudioTapProcessor!, didReceive buffer: AVAudioPCMBuffer!) {
        if buffer != nil{
            let outBuffer = dataConverter?.convertPCMBuffer(buffer: buffer)
            let data = outBuffer?.toData()
            session.recognize(audio: data!)
        }
    }
}

extension SpeechProcessor {
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup the AVAudioSession.")
        }
    }
}


extension SpeechProcessor : SpeechTextResultHandleDelegate{
    func process(data: TextData, completion: (_ text: String?) -> Void) {
          let sourceLangauge =  "en"//Language.detectedLangauge(data.text)
          self.languageTranslator?.translate(text: data.text!,
                                             source: sourceLangauge,
                                             target: self.targetLanguage!)
          completion(_: data.text)
    }
}


protocol SpeechTextResultHandleDelegate {
    func process(data: TextData, completion: (_ text: String?) ->Void)
}
/**
* Text index
*/
struct TextData{
    var text: String?
    var ratio: Int?
}

class SpeechTextResultHandler{
    private var textData: TextData!
    private var RatioPercent = 20
    var delegate: SpeechTextResultHandleDelegate?
    var targetedLanguage: String?
    
    func handle(text: String){
        print(text)
        if textData == nil{
           textData = TextData(text: text, ratio: 0)
        }
        let ratio: (Int,Int) = (textData.text?.characterPrefixRatio(of: text)) as! (Int, Int)
 
        if(ratio.1 >= RatioPercent){
           textData.ratio = ratio.1
           textData.text = text
         }
         else{
            textData = TextData(text: text, ratio: ratio.1)
         }
         //delegate?.process(text: textData.text!)
        delegate?.process(data: textData, completion: {text in
            print("collection -- ")
         })

         Utils.printLog(log: "text ratio: \(ratio)")
         print("-------------------------------------------------")
    }
}

