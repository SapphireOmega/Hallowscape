class GameOver extends Phaser.Scene {
  constructor() {
    super("gameOver");

  }

  create() {
    this.createBackgrounds();

  //  this.credits = this.add.image(config.width / 2, config.height - 20, "credits");
    this.instructions = this.add.image(config.width / 2, config.height / 2 - 25, "gameover");

    this.pressEnter = this.add.image(config.width / 2, config.height - 40, "enter");
    this.counter = 0;



    this.keyEnter = this.input.keyboard.addKey("ENTER");
  }

  update() {
    this.parallaxScroller();

    // blink text
    if (this.counter > 15) {
      this.pressEnter.visible = true;
    } else {
      this.pressEnter.visible = false;
    }
    this.counter++;
    if (this.counter > 60) {
      this.counter = 0;
    }


    // controls
    if (Phaser.Input.Keyboard.JustDown(this.keyEnter)) {
      this.scene.start("playGame");

    }
  }

  createBackgrounds() {
    this.background = this.add.tileSprite(0, 0, config.width, config.height, "background");
    this.background.setOrigin(0, 0);
    this.background.setScrollFactor(0);
    //
    // this.columns = this.add.tileSprite(0, 0, config.width, config.height, "columns");
    // this.columns.setOrigin(0, 0);
    // this.columns.setScrollFactor(0);
  }

  parallaxScroller() {
    this.background.tilePositionX += 0.25;
    //this.columns.tilePositionX += 0.5;
  }

}
