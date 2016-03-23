//
//  Constants.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/9/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

struct Constants {
    struct Color{
        static let mildWhite = UIColor(hexString: "fafafa")
        
        struct Teal{
            static let light = UIColor(hexString: "75cbc3")
            static let medium = UIColor(hexString: "00B6AA") // Primary Teal
            static let dark = UIColor(hexString: "009688")
        }
        
        struct Orange{
            static let light = UIColor(hexString: "faa73f")
            static let medium = UIColor(hexString: "ff7043") // Bright orange
            static let dark = UIColor(hexString: "f68b1f")
        }
        
        struct Purple{
            static let light = UIColor(hexString: "a45585")
            static let dark = UIColor(hexString: "65416c")
        }
        
        struct Gray{
            static let light = UIColor(hexString: "eeeeee")
            static let medium = UIColor(hexString: "bebebe")
            static let dark = UIColor(hexString: "48484A")
            static let blackish = UIColor(hexString: "212121")
        }
        
        struct DirtyGray{
            static let light = UIColor(hexString: "90a4ae")
            static let mild = UIColor(hexString: "969696")
            static let medium = UIColor(hexString: "546e7a")
            static let dark = UIColor(hexString: "3d414c")
        }
        
        struct Green {
            static let light = UIColor(hexString: "00b200")
            static let mild = UIColor(hexString: "009900")
            static let medium = UIColor(hexString: "007f00")
            static let dark = UIColor(hexString: "006600")
            
        }
        
        struct Red {
            static let light = UIColor(hexString: "e55100")
            static let mild = UIColor(hexString: "cc4800")
            static let medium = UIColor(hexString: "b23e00")
            static let dark = UIColor(hexString: "993600")
        }
    }
    
    struct Api{
        struct Meetup{
            static let apiKey = "30197727133c6196f5c1d2678271c12"
            struct Consumer{
                static let key = "c3ac9gl0gn114labhch4jnig95"
                static let secret = "n85kukjjnjbs4kao2eg7714drv"
            }
        }
        
        struct Slack{
            static let clientId = "23398940453.26339368899"
            static let clientSecret = "143fc69c2b2c1007d1aa55f40c4d5e7b"
        }
        
        struct Parse{
            static let appId = "sW8VXwGAEeq8FYaKMgcbPfliodb8XA7wx0QXLdx9"
            static let clientKey = "HTVvl8X9szeaOlXzI8jEUx0MENGlzDTrCIrPCnIy"
        }
    }
}
