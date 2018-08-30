//
//  CustomPlayerViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/22/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import VGPlayer

class CustomPlayerViewController:  UIViewController{
    private var langNotification =  Notification.Name("SELECTED_LANGUAGE")
    private var speechProcessor : SpeechProcessor!
    private var selectedLanguage: String? = "fr" {
        didSet{
            speechProcessor.targetLanguage = selectedLanguage
        }
    }

    var player = VGPlayer()
    var url : URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.player.displayView)
        
        self.player.play()
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.view.snp.top)
            make.left.equalTo(strongSelf.view.snp.left)
            make.right.equalTo(strongSelf.view.snp.right)
            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(3.0/4.0)///3.0/4.0) // you can 9.0/16.0
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewVideo(_:)),
                                               name: VideoViewCell.VideoNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(selectLanguage(_:)),
                                               name: langNotification,
                                               object: nil)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.player.cleanPlayer()
        
        NotificationCenter.default.removeObserver(self, name: VideoViewCell.VideoNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: langNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func viewVideo( _ notification : NSNotification){
        print("video notification \(notification)")
        guard let videoData: VideoTableViewController.VideoData = notification.userInfo!["data"] as? VideoTableViewController.VideoData
        else{
            return
        }
        self.speechProcessor = SpeechProcessor()
        self.player.replaceVideo(videoData.videoUrl!)
        self.player.displayView.titleLabel.text = videoData.title
        self.speechProcessor.connectPlayer(player: self.player.player, itemUrl: videoData.videoUrl)
        self.speechProcessor.languageTranslator = WatsonLanguageTranslator()
        self.speechProcessor.targetLanguage = self.selectedLanguage
        self.player.play()
        self.player.player?.volume = 0.0
    }
    
    @objc func selectLanguage(_ notification : NSNotification){
        let language = notification.userInfo!["data"] as! String
        let code = NSLocale.canonicalLocaleIdentifier(from: language)
        self.selectedLanguage =  code
    }
}

extension CustomPlayerViewController: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        switch state {
        case .playing:
             self.speechProcessor.toggleSession(paused: false)
        default:
             self.speechProcessor.toggleSession(paused: true)
        }
        
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}
    
extension CustomPlayerViewController: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
       // UIApplication.shared.prefersStatusBarHidden(
        
    }
}

