import Scenes

class TitleScene : Scene {

    let background = TitleLayer()


    init() {
        super.init(name:"Title")

        insert(layer:background, at:.front)
    }

}
