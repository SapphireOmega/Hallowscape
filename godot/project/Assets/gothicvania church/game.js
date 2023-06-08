/*
* GothicVania Church Demo Display
* Created by @ansimuz (ansimuz.com)
* Get more free assets and code like these at: www.pixelgameart.org
* Visit my store for premium content at https://ansimuz.itch.io/
*/

let game;

let config = {
  width: 384,
  height: 224,
  backgroundColor: 0x000000,
  scene: [BootGame,TitleScreen, PlayGame, GameOver],
  pixelArt: true,
  physics: {
    default: "arcade",
    arcade:{
        gravity:{
          y: 400
        },
        debug: false,
        debugShowVelocity: false
    }
  }
}



window.onload = function(){
  game = new Phaser.Game(config);
  window.focus();
  resize();
  window.addEventListener("resize", resize, false);
}

// resize window

function resize(){
    let canvas = document.querySelector("canvas");
    let windowWidth = window.innerWidth;
    let windowHeight = window.innerHeight;
    let windowRatio = windowWidth / windowHeight;
    let gameRatio = game.config.width / game.config.height;
    if(windowRatio < gameRatio){
        canvas.style.width = windowWidth + "px";
        canvas.style.height = (windowWidth / gameRatio) + "px";
    }
    else{
        canvas.style.width = (windowHeight * gameRatio) + "px";
        canvas.style.height = windowHeight + "px";
    }
}
