class BootGame extends Phaser.Scene {
  constructor() {
    super("bootGame");
  }

  preload() {
    // loadbar
    this.bar = new Bar({ scene: this });

    // load assets
    // load tiled map
    this.load.tilemapTiledJSON("map", "assets/map/map.json");
      this.load.image("tileset", "assets/environment/tileset.png");
    // images
    this.load.image("background", "assets/environment/background.png");
    this.load.image("columns", "assets/environment/columns.png");
    // atlas
    this.load.atlas("atlas", "assets/atlas/atlas.png", "assets/atlas/atlas.json" );
    // audio
    this.load.audio("attack", "assets/sounds/attack.ogg");
    this.load.audio("hurt", "assets/sounds/hurt.ogg");
    this.load.audio("jump", "assets/sounds/jump.ogg");
    this.load.audio("kill", "assets/sounds/kill.ogg");
    this.load.audio("music", "assets/sounds/ockaie_temple.ogg");
    // title assets
    this.load.image("title", "assets/images/title-screen.png");
    this.load.image("credits", "assets/images/credits-text.png");
    this.load.image("enter", "assets/images/press-enter-text.png");
    this.load.image("instructions", "assets/images/instructions.png");
    this.load.image("gameover", "assets/images/game-over.png");

  }

  create() {

    this.scene.start("titleScreen");
  }
}


class Bar extends Phaser.GameObjects.Container{
  constructor(config){
    super(config.scene);
    this.scene = config.scene;

    let progressBar = this.scene.add.graphics();
    let progressBox = this.scene.add.graphics();
    let boxWidth = 80;
    let boxHeight = 10;
    let barWidth = boxWidth - 4;
    let barHeight = boxHeight - 4;
    let boxCenterX = game.config.width / 2 - boxWidth/2;
    let boxCenterY = game.config.height / 2 - boxHeight/2 ;
    let barCenterX = boxCenterX + 2;
    let barCenterY = boxCenterY + 2;

    progressBox.fillStyle(0xffffff, 0.6);
    progressBox.fillRect(boxCenterX, boxCenterY, boxWidth, boxHeight);

    this.scene.load.on('progress', function(value) {
      var mybarWidth = barWidth - 4;
      progressBar.clear();
      progressBar.fillStyle(0xffffff, 1);
      progressBar.fillRect(barCenterX , barCenterY, barWidth * value, barHeight);
    });

   }
}
