//
//  UICollectionView+Extension.swift
//  YiBiFen_CN
//
//  Created by Hanson on 28/12/2017.
//  Copyright © 2017 hhly. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerClassOf<T: UICollectionViewCell>(_: T.Type)  {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func registerClassOf<T: UICollectionReusableView>(_: T.Type, elementKind: String)  {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    func registerNibOf<T: UICollectionViewCell>(_: T.Type) {

        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }


    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath)
        -> T {
            guard let cell = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
                fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            }
            return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {

        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

}
