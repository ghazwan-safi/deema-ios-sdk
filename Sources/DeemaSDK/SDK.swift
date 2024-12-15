

import SwiftUI

 

public struct SDK : View {
    public init(buttonTapped: @escaping () -> Void) {
        self.buttonTapped = buttonTapped
    }
    
    let buttonTapped: ()->Void

    public var body: some View {
        Text("I am sdk")
            .background(Color.white)
    }
}
