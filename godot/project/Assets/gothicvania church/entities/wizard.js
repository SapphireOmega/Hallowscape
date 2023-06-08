class Wizard extends Phaser.GameObjects.Sprite{
  constructor(scene, x, y){
    x *= 16;
    y *= 16;
    super(scene, x, y, "atlas", "wizard-idle-1");

    this.scene = scene;

    scene.add.existing(this);
    scene.enemies.add(this);

    this.castCounter = 0;
    this.castTime = 160;

    // set setSize
    this.setOrigin(0.5, 0.5);
    this.body.setSize(11,37);
    this.body.offset.y = 29;

    scene.anims.create({
      key: "wizard_idle",
      frames: scene.anims.generateFrameNames("atlas",{
          prefix: "wizard-idle-",
          start: 1,
          end: 5
      }),
      frameRate: 10,
      repeat: -1
    });

    scene.anims.create({
      key: "wizard_fire",
      frames: scene.anims.generateFrameNames("atlas",{
          prefix: "fire",
          start: 1,
          end: 10
      }),
      frameRate: 10,
      repeat: 0
    });

    this.play("wizard_idle");
    this.on('animationcomplete', this.animComplete, this);
    this.on("animationupdate", this.animUpdate, this);

    this.flipX = true;

  }

  animUpdate(animation, frame, sprite){
    if(animation.key == "wizard_fire" && frame.index == 7){
       var fireball = new FireBall(this.scene, this.x, this.y + 6, this.flipX);
    }
  }

  animComplete(animation, frame, sprite){
    if(animation.key == "wizard_fire"){
       this.play("wizard_idle");
    }
  }

  create(){
  }

  update(){


    // flip
    if(this.scene.player.x > this.x){
        this.flipX = true;
    }else{
      this.flipX = false;
    }

    // cast fireball
    if(this.castCounter++ > this.castTime){
      this.castCounter = 0;
      this.play("wizard_fire");
    }


  }

}


class FireBall extends Phaser.GameObjects.Sprite{
  constructor(scene, x, y, dir){
    super(scene, x, y, "atlas", "fireball1");


    this.speed = 80;

    this.destroyCounter = 0;

    this.scene = scene;
    scene.add.existing(this);
    scene.projectiles.add(this);
    this.body.setAllowGravity(false);


    // set setSize
    this.setOrigin(0.5, 0.5);
    this.body.setSize(12,12, true);

    scene.anims.create({
      key: "fireball",
      frames: scene.anims.generateFrameNames("atlas", {
        prefix: "fireball",
        start: 1,
        end: 3
      }),
      frameRate: 20,
      repeat: -1
    });

    this.play("fireball");

    if(dir){
      this.x += 38;
      this.body.velocity.x = this.speed ;
    }else{
      this.x -= 38;
      this.body.velocity.x = -this.speed ;
    }


  }

  update(){
    if(this.destroyCounter++ > 100){
      this.destroy();
    }
  }
}
