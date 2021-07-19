//
//  AppTrackingTransparency.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/16.
//

import UIKit
import AdSupport
import AppTrackingTransparency


func setUpAppTrackimgTransparency() {
    if #available(iOS 14, *) {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            print("Allow Tracking")
            print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
        case .denied:
            print("😭拒否")
        case .restricted:
            print("🥺制限")
        case .notDetermined:
            showRequestTrackingAuthorizationAlert()
        @unknown default:
            fatalError()
        }
    } else {// iOS14未満
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            print("Allow Tracking")
            print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
        } else {
            print("🥺制限")
        }
    }
}

///Alert表示
func showRequestTrackingAuthorizationAlert() {
    if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .authorized:
                print("🎉")
                //IDFA取得
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied, .restricted, .notDetermined:
                print("😭")
            @unknown default:
                fatalError()
            }
        })
    }
}
