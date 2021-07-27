//
//  Sound.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/27.
//

import UIKit
import AVFoundation

let taskIsDoneSound = Bundle.main.bundleURL.appendingPathComponent("piko.mp3")
var taskIsDoneSoundPlayer = AVAudioPlayer()

let taskIsUndoneSound = Bundle.main.bundleURL.appendingPathComponent("huin.mp3")//ka.mp3
var taskIsUndoneSoundPlayer = AVAudioPlayer()

let bingoSound = Bundle.main.bundleURL.appendingPathComponent("done.mp3")
var bingoSoundPlayer = AVAudioPlayer()

let clearSound = Bundle.main.bundleURL.appendingPathComponent("pioooin.mp3")//shuuun.mp3
var clearSoundPlayer = AVAudioPlayer()


func taskIsDoneSoundPlay() {
    do {
        taskIsDoneSoundPlayer = try AVAudioPlayer(contentsOf: taskIsDoneSound, fileTypeHint: nil)
        taskIsDoneSoundPlayer.volume = 1.0
        taskIsDoneSoundPlayer.play()
    } catch let err {
        print("効果音の再生に失敗しました。", err)
    }
}


func taskIsUndoneSoundPlay() {
    do {
        taskIsUndoneSoundPlayer = try AVAudioPlayer(contentsOf: taskIsUndoneSound, fileTypeHint: nil)
        taskIsUndoneSoundPlayer.volume = 1.0
        taskIsUndoneSoundPlayer.play()
    } catch let err {
        print("効果音の再生に失敗しました。", err)
    }
}


func bingoSoundPlay() {
    do {
        bingoSoundPlayer = try AVAudioPlayer(contentsOf: bingoSound, fileTypeHint: nil)
        bingoSoundPlayer.volume = 1.0
        bingoSoundPlayer.play()
    } catch let err {
        print("効果音の再生に失敗しました。", err)
    }
}


func clearSoundPlay() {
    do {
        clearSoundPlayer = try AVAudioPlayer(contentsOf: clearSound, fileTypeHint: nil)
        clearSoundPlayer.volume = 1.0
        clearSoundPlayer.play()
    } catch let err {
        print("効果音の再生に失敗しました。", err)
    }
}


func setUpSoundPrepare() {
    taskIsDoneSoundPlayer.prepareToPlay()
    taskIsUndoneSoundPlayer.prepareToPlay()
    clearSoundPlayer.prepareToPlay()
    bingoSoundPlayer.prepareToPlay()
}
