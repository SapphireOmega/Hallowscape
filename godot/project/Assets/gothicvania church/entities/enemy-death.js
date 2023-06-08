class Enemydeath extends Phaser.GameObjects.Sprite{
  constructor(scene, x, y){
    super(scene, x, y, "atlas", "enemy-death1");

    scene.add.existing(this);
    this.setOrigin(0.5,0.5);

    scene.anims.create({
      key: "enemy_death",
      frames: scene.anims.generateFrameNames("atlas",{
        prefix: "enemy-death",
        start: 2,
        end: 8
      }),
      frameRate: 15,
      repeat: 0,
      hideOnComplete: true
    });

    this.play("enemy_death");

  }
}
