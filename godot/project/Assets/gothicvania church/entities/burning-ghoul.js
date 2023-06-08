class BurningGhoul extends Phaser.GameObjects.Sprite{
  constructor(scene, x, y){
    x *= 16;
    y *= 16;
    super(scene, x, y, "atlas", "burning-ghoul1");

    this.speed = 100;

    scene.add.existing(this);
    scene.enemies.add(this);

    // set setSize
    this.setOrigin(0.5, 0.5);
    this.body.setSize(13,41);
    this.body.offset.y = 19;


    scene.anims.create({
      key: "run",
      frames: scene.anims.generateFrameNames("atlas", {
        prefix: "burning-ghoul",
        start: 1,
        end: 8
      }),
      frameRate: 15,
      repeat: -1
    });

    this.play("run");
  }

  update(){

    // change velocity
    if(this.flipX){
      this.body.velocity.x = this.speed;
    }else{
      this.body.velocity.x = -this.speed;
    }

    // turn around on touching walls
    if(this.body.onWall()){
          if(this.flipX){
            this.flipX = false;
            this.x -= 5;
          }else{
            this.flipX = true;
            this.x += 5;
          }

    }

  }
}
