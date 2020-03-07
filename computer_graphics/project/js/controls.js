/*
  File in charge of the controls in game
*/

function keyInput() {
    var rotSpeed = 0.005;

    if (camera.position.y > 4.95 && camera.position.y < 5.05){
        arrow.then(obj => {
            obj.scale.set(0.2, 0.2, 0.2);
        });
    }

    if (camera.position.x > -0.95 && camera.position.x < 0.05){
        arrow.then(obj => {
            //obj.rotateY( Math.PI / 2.065 );
        });
    }

    var x = camera.position.x, y = camera.position.y, z = camera.position.z;
    if( keyboard.pressed("W") ){
      if((y * Math.cos(4 * rotSpeed) + y * Math.sin(4 * rotSpeed)) < 6.75) {
          camera.position.y = y * Math.cos(4 * rotSpeed) + y * Math.sin(4 * rotSpeed);
          arrow.then(obj => {
              obj.scale.set( obj.scale.x,obj.scale.y - rotSpeed * 2,obj.scale.z - rotSpeed * 2);
          });
      }
    }
    if( keyboard.pressed("A") ){
        camera.position.x = x * Math.cos(rotSpeed) - z * Math.sin(rotSpeed);
        camera.position.z = z * Math.cos(rotSpeed) + x * Math.sin(rotSpeed);
        arrow.then(obj => {
              obj.rotateY(-rotSpeed);
              obj.position.x -= 7*rotSpeed/10;
        });
    }
    if( keyboard.pressed("S") ){
      if((y * Math.cos(4 * rotSpeed) - y * Math.sin(4 * rotSpeed)) > 3.585) {
          camera.position.y = y * Math.cos(4 * rotSpeed) - y * Math.sin(4 * rotSpeed);
          arrow.then(obj => {
              obj.scale.set( obj.scale.x,obj.scale.y + rotSpeed * 2,obj.scale.z + rotSpeed * 2);
          });
      }
    }
    if( keyboard.pressed("D") ){
        camera.position.x = x * Math.cos(rotSpeed) + z * Math.sin(rotSpeed);
        camera.position.z = z * Math.cos(rotSpeed) - x * Math.sin(rotSpeed);
        arrow.then(obj => {
            obj.rotateY(rotSpeed);
            obj.position.x += 7*rotSpeed/10;
        });
    }

    if (keyboard.pressed("I")){
      paperball.then(obj => {
        obj.position.z += 0.02;
      });
    }
    if (keyboard.pressed("K")){
      paperball.then(obj => {
        obj.position.z -= 0.02;
      });
    }
    if (keyboard.pressed("J")){
      paperball.then(obj => {
        obj.position.x += 0.02;
      });
    }
    if (keyboard.pressed("L")){
      paperball.then(obj => {
        obj.position.x -= 0.02;
      });
    }
    if(keyboard.pressed("enter")){
      spawnSphere();
    }

    if (booleanSpace == 0) {
        if(keyboard.pressed("space")){
          var x, y, z;

          arrow.then(obj => {
              switch(ballSelection) {
                  case 2:
                      multiplyScalar = 60 * obj.scale.y;
                      break;
                  case 3:
                      multiplyScalar = 12 * obj.scale.y;
                      break;
                  default:
                      multiplyScalar = 40 * obj.scale.y;
              }
          });

          arrow.then(obj => {
              x = obj.position.x;
              y = obj.position.y;
              z = obj.position.z;
          });
          raycaster.set( new THREE.Vector3( paperSphere.position.x, paperSphere.position.y, paperSphere.position.z ),
            new THREE.Vector3(-x, y, -z).normalize() );
        }

        if(keyboard.up("space")){
          if(multiplyScalar > 15){
            multiplyScalar = 15;
          }

          paperSphere.position.copy(raycaster.ray.direction);
          paperSphere.position.add(raycaster.ray.origin);

          var pos = new THREE.Vector3();
          pos.copy( raycaster.ray.direction );
                pos.multiplyScalar( multiplyScalar );
                paperSphere.setLinearVelocity( new THREE.Vector3( pos.x, pos.y, pos.z ) );

          multiplyScalar = 0;
          booleanSpace = 1;
        }
    }

    camera.lookAt(0, 1, 8);
}
