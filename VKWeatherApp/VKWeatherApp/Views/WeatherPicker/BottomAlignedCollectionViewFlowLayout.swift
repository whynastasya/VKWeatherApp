//
//  BottomAlignedCollectionViewFlowLayout.swift
//  VKWeatherApp
//
//  Created by nastasya on 20.07.2024.
//

import UIKit

final class BottomAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttribute.indexPath)?.frame {
                    layoutAttribute.frame = newFrame
                }
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        attributes?.frame.origin.y = collectionViewContentSize.height - (attributes?.frame.height ?? 0)
        return attributes
    }
}

