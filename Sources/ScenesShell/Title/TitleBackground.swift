import Scenes
import Igis
import Foundation


class  TitleLayer : Layer {
    let background = TitleBackground()

    init() {
        super.init(name:"TitleScreen")

        insert(entity:background, at:.front)
    }

}
                     
