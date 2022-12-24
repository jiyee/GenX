//
//  AutoStartManager.swift
//  ClashX
//
//  Created by CYC on 2018/6/14.
//  Copyright © 2018年 yichengchen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ServiceManagement

public class LaunchAtLogin {
    static let shared = LaunchAtLogin()

    private init() {
        isEnableVariable.accept(isEnabled)
    }

    public var isEnabled: Bool {
        get {
            return LoginServiceKit.isExistLoginItems()
        }
        set {
            if newValue {
                LoginServiceKit.addLoginItems()
            } else {
                LoginServiceKit.removeLoginItems()
            }
            isEnableVariable.accept(newValue)
        }
    }

    var isEnableVariable = BehaviorRelay<Bool>(value: false)
}
