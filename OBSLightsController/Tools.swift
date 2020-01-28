//
//  Tools.swift
//  OBSLightsController
//
//  Created by Songmin Kim on 1/24/20.
//  Copyright © 2020 Center for Language & Technology. All rights reserved.
//

import Foundation

func countVolumes() -> Int{
    let keys: [URLResourceKey] = [.volumeNameKey, .volumeIsRemovableKey, .volumeIsEjectableKey]
    let paths = FileManager().mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [])
    var i: Int = 0
    
    if let urls = paths {
        
        for url in urls {
            let components = url.pathComponents
            if components.count > 1 && components[1] == "Volumes" {
                i += 1
            }
        }
    }
    return i
}
