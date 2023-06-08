class Angel extends Phaser.GameObjects.Sprite{
  constructor(scene,x,y){
    x *= 16;
    y *= 16;
    super(scene, x, y, "atlas", "angel1");

    scene.add.existing(this);
    scene.enemies.add(this);

    this.body.setAllowGravity(false);

    // set Size
    this.setOrigin(0.5,0.5);
    this.body.setSize(13,35);
    this.body.offset.y = 50;

    scene.anims.create({
      key: "angel_fly",
      frames: scene.anims.generateFrameNames("atlas", {
        prefix: "angel",
        start: 1,
        end: 8
      }),
      frameRate: 10,
      repeat: -1
    });

    this.play("angel_fly");
  }
}
