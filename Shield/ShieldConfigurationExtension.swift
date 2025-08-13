//
//  ShieldConfigurationExtension.swift
//  Shield
//
//  Created by Alyssa H on 2025-08-07.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: UIColor(named: "shieldBg"),
            icon: UIImage(named: "shieldIcon"),
            title: ShieldConfiguration.Label(text: "Good things take time.", color: UIColor(named: "titleColour")!),
            subtitle: ShieldConfiguration.Label(text: "Take a breath, reset. You got this! To access app tap your tomato brick.", color: UIColor(named: "textColour")!),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Focus", color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)),
            primaryButtonBackgroundColor: UIColor(red: 0.26, green: 0.23, blue: 0.23, alpha: 0.8)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundColor: UIColor(named: "shieldBg"),
            icon: UIImage(named: "shieldIcon"),
            title: ShieldConfiguration.Label(text: "Good Things Take Time", color: UIColor(named: "textColour")!),
            subtitle: ShieldConfiguration.Label(text: "Take a breath, reset. You got this! To access app tap your tomato brick.", color: UIColor(named: "textColour")!),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Focus", color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)),
            primaryButtonBackgroundColor: UIColor(red: 0.21, green: 0.18, blue: 0.18, alpha: 1.0)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundColor: UIColor(named: "shieldBg"),
            icon: UIImage(named: "shieldIcon"),
            title: ShieldConfiguration.Label(text: "Good Things Take Time", color: UIColor(named: "textColour")!),
            subtitle: ShieldConfiguration.Label(text: "Take a breath, reset. You got this! To access app tap your tomato brick.", color: UIColor(named: "textColour")!),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Focus", color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)),
            primaryButtonBackgroundColor: UIColor(red: 0.21, green: 0.18, blue: 0.18, alpha: 1.0)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundColor: UIColor(named: "shieldBg"),
            icon: UIImage(named: "shieldIcon"),
            title: ShieldConfiguration.Label(text: "Good Things Take Time", color: .white),
            subtitle: ShieldConfiguration.Label(text: "Take a breath, reset. You got this! To access app tap your tomato brick.", color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Focus", color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)),
            primaryButtonBackgroundColor: UIColor(red: 0.21, green: 0.18, blue: 0.18, alpha: 1.0)
        )
    }
}
