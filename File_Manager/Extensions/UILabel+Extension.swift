//
//  File.swift
//  File_Manager
//
//  Created by Артем Калинкин on 27.01.2022.
//

import UIKit

extension UILabel
{
  func addCharacterSpacing(kernValue: Double = 1.15) {
    guard let text = text, !text.isEmpty else { return }
    let string = NSMutableAttributedString(string: text)
    string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
    attributedText = string
  }
  
  static func createStatisticLabel(with text: String, fontSize: CGFloat? = nil) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFontMetrics.default.scaledFont(for: Fonts.robotoMedium.withSize(fontSize ?? 22))
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = Colors.labelStatisticColor
    label.text = text
    label.addCharacterSpacing(kernValue: -0.33)
    return label
  }
  
  static func createDescriptionStatisticsLabel(with text: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFontMetrics.default.scaledFont(for: Fonts.robotoMediumForCategories.withSize(15))
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = Colors.labelGrayColor
    label.text = text
    label.addCharacterSpacing(kernValue: -0.33)
    return label
  }
}
