class PlayGame extends Phaser.Scene {
  constructor() {
    super("playGame");
  }

  create() {
    this.createBackgrounds();
    this.createTileMap();
    this.bindKeys();
    this.populateEnemies();

    // create audios
    this.audioAttack = this.sound.add("attack");
    this.audioHurt = this.sound.add("hurt");
    this.audioJump = this.sound.add("jump");
    this.audioKill = this.sound.add("kill");
    this.music = this.sound.add("music", {loop: true, volume: 0.5});
     this.music.play();


    this.projectiles = this.physics.add.group();

    // set player
    this.player = new Player(this, 5 * 16, 9 * 16);


    this.input.enabled = true;

    // add hit box
    this.hitBox = this.physics.add.image(this.player.x, this.player.y,  null);
    this.hitBox.visible = false;
    this.hitBox.setSize(40, 50);
    this.hitBox.body.setAllowGravity(false);


    // camera
    this.cameras.main.setBounds(0, 0, this.map.widthInPixels, this.map.heightInPixels);
    this.cameras.main.startFollow(this.player);

    // physics
    this.physics.add.collider(this.mainLayer, this.player);
    this.physics.add.collider(this.mainLayer, this.enemies);
    // overlaps
    this.physics.add.overlap(this.hitBox, this.enemies, this.hitEnemy, null, this);
    this.physics.add.overlap(this.player, this.enemies, this.hurtPlayer, null, this);
    this.physics.add.overlap(this.player, this.projectiles, this.hurtPlayer, null, this);

  }

  hurtPlayer(player, enemy){
     if(!player.isHurt ){
      player.isHurt = true;
      player.body.velocity.y = -150;
      player.body.velocity.x = (player.x > enemy.x) ? -100 : 100;
      this.audioHurt.play();
     }
  }

  hitEnemy(hitbox, enemy){
     if(this.player.isAttacking || this.player.isAirAttacking){
      var temp = new Enemydeath(this, enemy.x, enemy.y );
      enemy.destroy();
      this.audioKill.play();
     }
  }

  createBackgrounds() {
    this.background = this.add.tileSprite(0, 0, config.width, config.height, "background");
    this.background.setOrigin(0, 0);
    this.background.setScrollFactor(0);
    //
    this.columns = this.add.tileSprite(0,0,config.width, config.height, "columns");
    this.columns.setOrigin(0,0);
    this.columns.setScrollFactor(0);
  }


  createTileMap() {
    this.map = this.make.tilemap({
      key: "map",
      tileWidth: 16,
      tileHeight: 16
    });
    const tileset = this.map.addTilesetImage("tileset");
    //
    this.backLayer = this.map.createStaticLayer("Back Layer", tileset, 0, 0);
    //
    this.mainLayer = this.map.createStaticLayer("Main Layer", tileset, 0, 0);
    this.mainLayer.setCollisionByProperty({
      collides: true
    });


  }

  bindKeys(){
    this.keyRight = this.input.keyboard.addKey("RIGHT");
    this.keyLeft = this.input.keyboard.addKey("LEFT");
    this.keyJump = this.input.keyboard.addKey("X");
    this.keyJump2 = this.input.keyboard.addKey("K");
    this.keyCrouch = this.input.keyboard.addKey("DOWN");
    this.keyAttack = this.input.keyboard.addKey("C");
  }

  populateEnemies(){

    this.enemies = this.physics.add.group();

    var ghoul = new BurningGhoul(this, 20, 9);
    var ghoul = new BurningGhoul(this, 31, 9);
    var wizard = new Wizard(this, 42, 5);
    var wizard = new Wizard(this, 62, 3);
    var angel = new Angel(this, 71, 4);
    var wizard = new Wizard(this, 95, 6);
    var angel = new Angel(this, 108, 2);
    var ghoul = new BurningGhoul(this, 159, 7);
    var wizard = new Wizard(this, 171, 5);
    var angel = new Angel(this, 188, 8);
    var wizard = new Wizard(this, 203, 7);
    var ghoul = new BurningGhoul(this, 209, 9);
    var angel = new Angel(this, 223, 3);
    var wizard = new Wizard(this, 235, 3);
    var angel = new Angel(this, 240, 6);
  }


  update() {
    this.playerController();
    this.parallaxScroller();

    // update entities
    this.player.update();
    // update enemies
    this.enemies.children.each(function(enemy){
      enemy.update();
    } ,this);
    // // update prejectiles
    this.projectiles.children.each(function(projectile){
      projectile.update();
    } ,this);

    this.attachHitBox();


// 256
    // exit game
    if(this.player.x > 256 * 16 ){
      this.scene.start("gameOver");
       this.music.stop();
    }




  }

  attachHitBox(){
    // make hitbox follow player
    this.hitBox.x = (this.player.flipX) ? this.player.x - 24: this.player.x + 24;
    this.hitBox.y = this.player.y + 10;
  }

  parallaxScroller(){
      this.background.tilePositionX = this.cameras.main.scrollX * 0.25;
      this.columns.tilePositionX = this.cameras.main.scrollX * 0.5;
  }



  playerController() {

    if (this.player.isAttacking || this.player.isAirAttacking ) {
      return;
    }

    if (this.keyRight.isDown) {
      this.player.moveRight();
    } else if (this.keyLeft.isDown) {
      this.player.moveLeft();
    } else {
      this.player.stopMove();
    }

    if ((this.keyJump.isDown || this.keyJump2.isDown) &&
      this.player.body.onFloor() && !this.player.isCrouching) {
      this.player.jump();
    }

    if (this.keyCrouch.isDown && this.player.body.onFloor()) {
      this.player.crouch();
    } else if (this.keyCrouch.isUp) {
      this.player.standUp();
    }


    if (Phaser.Input.Keyboard.JustDown(this.keyAttack)) {
      if(this.player.isCrouching){
          this.player.crouchAttack();
      }else if(this.player.body.onFloor()){
          this.player.attack();

      }else{
        this.player.airAttack();
      }

    }


  }

}
