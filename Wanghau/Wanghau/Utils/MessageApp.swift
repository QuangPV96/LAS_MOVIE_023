import Foundation
import SwiftMessages

class MessageApp {
    static let shared = MessageApp()
    let commonMessage = SwiftMessages()
    var sharedConfiguration: SwiftMessages.Config {
        var configuration = SwiftMessages.Config()
        configuration.presentationStyle = .bottom
        configuration.duration = .forever
        configuration.dimMode = .gray(interactive: true)
        configuration.interactiveHide = true
        configuration.preferredStatusBarStyle = .lightContent
        return configuration
    }
}

extension MessageApp {
    func showMessage(messageType type: Theme, withTitle title: String = "", message: String, completion: (() -> Void)? = nil, duration: SwiftMessages.Duration = .seconds(seconds: 3)) {
        var config = sharedConfiguration
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(type)
        view.button?.isHidden = true
        view.configureContent(title: title, body: message)
        view.configureDropShadow()
        config.duration = duration
        config.eventListeners = [{ event in
            switch event {
            case .didHide:
                completion?()
            default:
                break
            }
            }]
        commonMessage.show(config: config, view: view)
    }
    
    func showMessage(messageType type: Theme, withTitle title: String = "", message: String, completion: (() -> Void)? = nil, duration: SwiftMessages.Duration = .seconds(seconds: 3), config: SwiftMessages.Config) {
        var config = config
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(type)
        view.button?.isHidden = true
        view.configureContent(title: title, body: message)
        view.configureDropShadow()
        config.duration = duration
        config.eventListeners = [{ event in
            switch event {
            case .didHide:
                completion?()
            default:
                break
            }
            }]
        commonMessage.show(config: config, view: view)
    }
    
    
    func quickSuccessMessageCenter(message: String) {
        
    }
}
