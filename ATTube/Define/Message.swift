//
//  Message.swift
//  ATTube
//
//  Created by Quang Phù on 8/30/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import SwiftMessages

class Message {

    static func success(title: String = Strings.success, subTitle: String = Strings.successMessage) {
        let success = MessageView.viewFromNib(layout: .CardView)
        success.configureTheme(.Success)
        success.configureDropShadow()
        success.configureContent(title: title, body: subTitle)
        success.button?.hidden = true
        var successConfig = SwiftMessages.Config()
        successConfig.presentationStyle = .Bottom
        successConfig.presentationContext = .Window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: successConfig, view: success)
    }

    static func warning(title: String = Strings.warning, subTitle: String = Strings.warningMessage) {
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.Warning)
        warning.configureDropShadow()
        warning.configureContent(title: title, body: subTitle, iconText: "🤔")
        warning.button?.hidden = true
        var warningConfig = SwiftMessages.Config()
        warningConfig.presentationStyle = .Bottom
        warningConfig.presentationContext = .Window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
}
