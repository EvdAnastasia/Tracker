//
//  GenericEventConstants.swift
//  Tracker
//
//  Created by Anastasiia on 13.01.2025.
//

import UIKit

enum GenericEventConstants {
    static let nameTextLimit = 38
    static let nameFieldHeight: CGFloat = 75
    static let habitOptionsTableViewRowHeight: CGFloat = 75.5
    static let habitOptionsTableViewHeight: CGFloat = 75
    static let buttonsStackViewHeight: CGFloat = 60
    static let nameFieldPadding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 45)
    static let collectionViewInset: CGFloat = 18
    static let collectionViewInsetLarge: CGFloat = 24
    static let collectionViewCellSpacing: CGFloat = 5
    static let collectionViewCellCountForRow = 6
    static let collectionViewCellSize: CGFloat = 52
    static let collectionViewHeaderHeight: CGFloat = 34
    static let collectionViewRowCountForSection = 3
    
    static let styleCellReuseIdentifier: String = "StyleCell"
    static let styleHeaderReuseIdentifier: String = "StyleHeaderSection"
    
    static let emoji: [String] = ["🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
    static let colors: [UIColor] = [.ypColorSelection1, .ypColorSelection2, .ypColorSelection3, .ypColorSelection4, .ypColorSelection5, .ypColorSelection6, .ypColorSelection7, .ypColorSelection8, .ypColorSelection9, .ypColorSelection10, .ypColorSelection11, .ypColorSelection12, .ypColorSelection13, .ypColorSelection14, .ypColorSelection15, .ypColorSelection16, .ypColorSelection17, .ypColorSelection18]
}
