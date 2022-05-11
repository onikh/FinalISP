import Scenes



class BattleScene : Scene {

    let backgroundLayer = BattleBGLayer()


    init() {
        super.init(name:"Battle")

        insert(layer:backgroundLayer, at:.back)
    }
}
