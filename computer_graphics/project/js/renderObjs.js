/*
  File in charge of seting up materials and objects to render
*/

'use strict';

//textures
const loader = new THREE.TextureLoader();
var textureFloor, textureWall;

textureFloor = THREE.ImageUtils.loadTexture( 'assets/img/carpet.jpg' );
textureWall = THREE.ImageUtils.loadTexture( 'assets/img/wall.jpg' );

// assuming you want the texture to repeat in both directions:
textureFloor.wrapS = THREE.RepeatWrapping; textureFloor.wrapT = THREE.RepeatWrapping;
textureWall.wrapS = THREE.RepeatWrapping; textureWall.wrapT = THREE.RepeatWrapping;

// how many times to repeat in each direction; the default is (1,1),
textureFloor.repeat.set( 4, 4 );
textureWall.repeat.set( 4, 4 );

// materials (colors)
var tableMaterial = Physijs.createMaterial(
    new THREE.MeshPhongMaterial( {
        color: 0xbdae99,
        opacity: 0.1
    }),
    friction,
    restitution
);

var trashcanMaterial = new THREE.MeshPhongMaterial( {
    color: 0x70818A,
    opacity: 0.5
} );

var arrowMaterial = new THREE.MeshPhongMaterial( {
    color: 0xf2b134,
    opacity: 0.5
} );

var shelfMaterial = new THREE.MeshPhongMaterial( {
    color: 0x334A5A,
    opacity: 0.5
} );

var transparentMaterial = Physijs.createMaterial(
    new THREE.MeshPhongMaterial( {
        color: 0xffffff,
        transparent: true,
        opacity: 0.1
    }),
    friction,
    restitution
);

var roomMaterial = Physijs.createMaterial(
    new THREE.MeshPhongMaterial({
        color: 0x70818A,
        transparent: false,
        opacity: 0.5,
        map: textureWall
        //side: THREE.BackSide
    }),
    friction,
    restitution
);

var floorMaterial = Physijs.createMaterial(
    new THREE.MeshPhongMaterial({
        color: 0x0894A1,
        transparent: false,
        opacity: 0.5,
        map: textureFloor
        //side: THREE.BackSide
    }),
    friction,
    restitution
);

var posterMaterial = Physijs.createMaterial(
    new THREE.MeshPhongMaterial({
        // color: 0x0894A1,
        transparent: false,
        opacity: 0.5,
        map: loader.load('assets/img/jadepicon.jpg'),
        //side: THREE.BackSide
    }),
    friction,
    restitution
);

// load an object using a promise. Allows to modify its propierties later
function loadObj( path, name ){
  var progress = console.log;

  return new Promise(function( resolve, reject ){
    var objLoader = new THREE.OBJLoader();

    objLoader.setPath( path );
    objLoader.load( name + ".obj", resolve, progress, reject );
  });
}

// draws the objects that form the room
function drawRoom() {
    // geometry
    floor = new THREE.BoxGeometry( 20, .6, 20 );
    wall = new THREE.BoxGeometry( 10, .6, 20 );
    poster = new THREE.BoxGeometry( 2, .1, 2 );

    // transparent side (outside)
    //mesh = new Physijs.BoxMesh( wall, transparentRoomMaterial, 0 );
    //scene.add( mesh );

    // colored side (inside)
    // floor
    mesh = new Physijs.BoxMesh( floor, floorMaterial, 0 );
    mesh.receiveShadow = true;
    mesh.name = "floor";
    scene.add( mesh );

    // left wall
    mesh = new Physijs.BoxMesh( wall, roomMaterial, 0 );
    mesh.rotateZ( rad( 90 ) );
    mesh.position.x = 10; mesh.position.y = 4.7;
    scene.add( mesh );

    // right wall
    mesh = new Physijs.BoxMesh( wall, roomMaterial, 0 );
    mesh.rotateZ( rad( 90 ) );
    mesh.position.x = -10; mesh.position.y = 4.7;
    scene.add( mesh );

    // back wall
    mesh = new Physijs.BoxMesh( wall, roomMaterial, 0 );
    mesh.rotateX( rad( 90 ) ); mesh.rotateY( rad( 90 ) );
    mesh.position.y = 4.7; mesh.position.z = -10;
    scene.add( mesh );

    // front wall
    mesh = new Physijs.BoxMesh( wall, roomMaterial, 0 );
    mesh.rotateX( rad( 90 ) ); mesh.rotateY( rad( 90 ) );
    mesh.position.y = 4.7; mesh.position.z = 10;
    scene.add( mesh );

    // poster
    mesh = new Physijs.BoxMesh( poster, posterMaterial, 0 );
    mesh.rotateX( rad( 90 ) ); mesh.rotateY( rad( 90 ) );
    mesh.position.y = 4.7; mesh.position.z = 9.5;
    scene.add( mesh );
}

// draws the props inside the room
function drawObjects(){

    // table
    table = loadObj( "assets/obj/", "table" );

    table.then(obj => {
      obj.traverse( function ( node ) { // adding color
          if ( node.isMesh ) node.material = tableMaterial;
      } );

      scene.add( obj );
    });

    // plane above the table
    plane = new THREE.PlaneGeometry( 4, 4, 32 );

    mesh = new Physijs.BoxMesh( plane, transparentMaterial );
    mesh.rotateX( rad( 90 ) );
    mesh.position.x = -.05; mesh.position.y = 2.7; mesh.position.z = -.5;
    mesh.name = "table";

    scene.add( mesh );

    // legs of table
    // front left
    leg = new THREE.BoxGeometry( .3, 2, .3 );
    mesh = new Physijs.BoxMesh( leg, transparentMaterial, 0 );
    mesh.position.x = 1.65; mesh.position.y = 1.3; mesh.position.z = 1.14;

    scene.add( mesh );

    // front right
    leg = new THREE.BoxGeometry( .3, 2, .3 );
    mesh = new Physijs.BoxMesh( leg, transparentMaterial, 0 );
    mesh.position.x = -1.75; mesh.position.y = 1.3; mesh.position.z = 1.14;

    scene.add( mesh );

    // back left
    leg = new THREE.BoxGeometry( .3, 2, .3 );
    mesh = new Physijs.BoxMesh( leg, transparentMaterial, 0 );
    mesh.position.x = 1.7; mesh.position.y = 1.3; mesh.position.z = -2.25;

    scene.add( mesh );

    // back right
    leg = new THREE.BoxGeometry( .3, 2, .3 );
    mesh = new Physijs.BoxMesh(leg, transparentMaterial, 0);
    mesh.position.x = -1.73; mesh.position.y = 1.3; mesh.position.z = -2.25;

    scene.add( mesh );

    // trashcan
    trashcan = loadObj( "assets/obj/", "trashcan" );

    trashcan.then(obj => {
      obj.traverse( function ( node ) { // adding color
          if ( node.isMesh ) node.material = trashcanMaterial;
      } );
      obj.scale.set( 0.5,0.5,0.5 );
      obj.position.y = 1.35; obj.position.z = 8;

      scene.add( obj );
    });

    // trashcan bottom
    trashbottom =  new THREE.CircleBufferGeometry( .4, 32 );
    mesh = new Physijs.BoxMesh(trashbottom, transparentMaterial, 0);
    mesh.rotateX( rad( 90 ) );
    mesh.position.x = -.25; mesh.position.y = .3; mesh.position.z = 8.4;
    mesh.name = "trashcan";

    scene.add( mesh );

    // trashcan walls
    trashwall =  new THREE.BoxGeometry( .01, 1.2, .4);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( -5 ) );
    mesh.position.x = .13; mesh.position.y = .9; mesh.position.z = 8.4;

    scene.add( mesh );

    trashwall =  new THREE.BoxGeometry( .01, 1.2, .5);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( -5 ) );
    mesh.rotateY( rad( -60) );
    mesh.position.x = -.05; mesh.position.y = .9; mesh.position.z = 8.7;

    scene.add( mesh );

    trashwall =  new THREE.BoxGeometry( .01, 1.2, .5);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( -5 ) );
    mesh.rotateY( rad( 60) );
    mesh.position.x = -.05; mesh.position.y = .9; mesh.position.z = 8.1;

    scene.add( mesh );

    trashwall =  new THREE.BoxGeometry( .01, 1.2, .4);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( 5 ) );
    mesh.position.x = -.65; mesh.position.y = .9; mesh.position.z = 8.4;

    scene.add( mesh );

    trashwall =  new THREE.BoxGeometry( .01, 1.2, .5);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( 5 ) );
    mesh.rotateY( rad( 60) );
    mesh.position.x = -.4; mesh.position.y = .9; mesh.position.z = 8.7;

    scene.add( mesh );

    trashwall =  new THREE.BoxGeometry( .01, 1.2, .5);
    mesh = new Physijs.BoxMesh(trashwall, transparentMaterial, 0);
    mesh.rotateZ( rad( 5 ) );
    mesh.rotateY( rad( -60) );
    mesh.position.x = -.4; mesh.position.y = .9; mesh.position.z = 8.1;

    scene.add( mesh );

    // arrow
    arrow = loadObj( "assets/obj/", "arrow" );

    arrow.then(obj => {
      obj.traverse( function ( node ) { // adding color
          if ( node.isMesh ) node.material = arrowMaterial;
      } );
      obj.scale.set( 0.2,0.2,0.2 );
      obj.rotateY( Math.PI / 2.065 ); obj.rotateZ( Math.PI / 19 );
      obj.position.x = -0.1; obj.position.y = 2.7; obj.position.z = 2;

      scene.add( obj );
    });
    
    // Iron Man
    onProgress = function ( xhr ) {
        if ( xhr.lengthComputable ) {
            percentComplete = xhr.loaded / xhr.total * 100;
            //console.log( Math.round(percentComplete, 2) + '% downloaded' );
        }
    };

    THREE.Loader.Handlers.add( /\.dds$/i, new THREE.DDSLoader() );
    mtlLoader = new THREE.MTLLoader();
    mtlLoader.setPath( 'assets/obj/materials/' );
    mtlLoader.load( 'IronMan.mtl', function( materials ) {
        materials.preload();
        var objLoader = new THREE.OBJLoader();
        objLoader.setMaterials( materials );
        objLoader.setPath( 'assets/obj/' );
        objLoader.load( 'IronMan.obj', function ( object ) {
            ironMan = object;
            object.scale.set( 0.003,0.003,0.003 );
            object.position.set(3.4, 4.3, 9);
            object.rotateY(Math.PI);
            scene.add( object );
        }, onProgress);
    });

    paperSphere = new Physijs.SphereMesh(
      new THREE.SphereGeometry( .2, 10, 10 ),
      transparentMaterial
    );

    // cancel movement of the ball
    paperSphere.setLinearVelocity(new THREE.Vector3(0, 0, 0));
    paperSphere.setAngularVelocity(new THREE.Vector3(0, 0, 0));
    paperSphere.setAngularFactor(new THREE.Vector3(0, 0, 0));

    // desk
    desk = loadObj( "assets/obj/", "desk" );

    desk.then(obj => {
      obj.traverse( function ( node ) { // adding color
          if ( node.isMesh ) node.material = tableMaterial;
      } );
      obj.position.x = -8.5; obj.position.y = .25; obj.position.z = 7;

      scene.add( obj );
    });

    // box for desk drawers
    deskbox = new THREE.BoxGeometry( 2.3, 2.9, 1.9 );

    mesh = new Physijs.BoxMesh( deskbox, transparentMaterial, 0 );
    mesh.position.x = -8.5; mesh.position.y = 1.5; mesh.position.z = 4.5;

    scene.add( mesh );

    // leg for desk
    leg = new THREE.BoxGeometry( 2.3, 2.9, .3 );

    mesh = new Physijs.BoxMesh( leg, transparentMaterial, 0 );
    mesh.position.x = -8.5; mesh.position.y = 1.5; mesh.position.z = 8.4;

    scene.add( mesh );

    // box above desk
    plane = new THREE.BoxGeometry( 2.3, 5, .25 );

    mesh = new Physijs.BoxMesh( plane, transparentMaterial, 0 );
    mesh.rotateX( rad( 90 ) );
    mesh.position.x = -8.5; mesh.position.y = 2.87; mesh.position.z = 6;

    scene.add( mesh );

    // shelf
    shelf = loadObj( "assets/obj/", "shelf" );

    shelf.then(obj => {
      obj.traverse( function ( node ) { // adding color
          if ( node.isMesh ) node.material = shelfMaterial;
      } );
      obj.scale.set( 2,2,2 );
      obj.rotateY( rad(180) );
      obj.position.x = 5; obj.position.y = 0; obj.position.z = 8.2;

      scene.add( obj );
    });

    shelfbox = new THREE.BoxGeometry( 4, 4.2, 1.5 );

    mesh = new Physijs.BoxMesh( shelfbox, transparentMaterial, 0 );
    mesh.position.x = 4.9; mesh.position.y = 2.2; mesh.position.z = 8.9;

    scene.add( mesh );

    // box with physics
    var box = new Physijs.BoxMesh(
			new THREE.CubeGeometry( .5, .5, .5 ),
			new THREE.MeshBasicMaterial({ color: 0xffffff })
		);
    box.addEventListener( 'collision', function( other_object, linear_velocity, angular_velocity ) {
      // `this` is the mesh with the event listener
      // other_object is the object `this` collided with
      // linear_velocity and angular_velocity are Vector3 objects which represent the velocity of the collision
      //score--;
      //console.log("Score ", score);
      //console.log("Box collided");
    });
    box.rotateX( rad( 30 ) );
    box.position.y = 10; box.position.z = 1.5;

		//scene.add( box );
}

/*
Object's references:
Iron Man: 
Deadcode3 (2013). “IronMan 3D Model.” Free3D. Retrieved from: https://free3d.com/3d-model/ironman-rigged-original-model--98611.html
Pokeball:
Speznaz97 (2017). “Pokeball 3D Model.” Free3D. Retrieved from: https://free3d.com/3d-model/pokeball-4613.html
Bowling ball:
Printable_models (2018). “Bowling Ball V1 3D Model.” Free3D. Retrieved from: https://free3d.com/3d-model/-bowling-ball-v1--953922.html
*/
function drawBall(){
    // Switch for ball selection
    switch(ballSelection) {
      case 2:
            // pokeball
            mtlLoader.setPath( 'assets/obj/materials/' );
            mtlLoader.load( 'pokeball.mtl', function( materials ) {
                materials.preload();
                var objLoader = new THREE.OBJLoader();
                objLoader.setMaterials( materials );
                objLoader.setPath( 'assets/obj/' );
                objLoader.load( 'pokeball.obj', function ( obj ) {
                    obj.position.x = 0;
                    obj.position.y = 0;
                    obj.position.z = 0;
                    obj.rotateY(Math.PI/2);
                    obj.scale.set(0.00189,0.00189,0.00189);
                    paperSphere.add(obj);
                }, onProgress);
            });
            break;
      case 3:
            // Bowling Ball
            mtlLoader.setPath( 'assets/obj/materials/' );
            mtlLoader.load( 'bowling.mtl', function( materials ) {
                materials.preload();
                var objLoader = new THREE.OBJLoader();
                objLoader.setMaterials( materials );
                objLoader.setPath( 'assets/obj/' );
                objLoader.load( 'bowling.obj', function ( obj ) {
                    obj.position.x = 0;
                    obj.position.y = 0;
                    obj.position.z = -0.2;
                    obj.scale.set(0.019,0.019,0.019);
                    paperSphere.add(obj);
                }, onProgress);
            });
            break;
      default:
            // paperball
            paperball = loadObj( "assets/obj/", "paperball" );

            paperball.then(obj => {
              obj.position.x = 0;
              obj.position.y = 0;
              obj.position.z = 0;
              paperSphere.add(obj);
            });
    }

    paperSphere.name = "paperball";
    paperSphere.castShadow = true;

    paperSphere.position.y = 2.9; paperSphere.position.z = 1;
    paperSphere.addEventListener( 'collision', function( other_object, linear_velocity, angular_velocity ) {

      if (other_object.name == "trashcan") {
        score += 10;
        document.getElementById('points').innerHTML = score;
        console.log("Pego con el bote");
      }
      if(other_object.name == "floor"){
        // reset position
        paperSphere.position.set( 0, 2.9, 1 );
        paperSphere.__dirtyPosition = true;
        // cancel movement of the ball
        paperSphere.setLinearVelocity(new THREE.Vector3(0, 0, 0));
        paperSphere.setAngularVelocity(new THREE.Vector3(0, 0, 0));
        paperSphere.setAngularFactor(new THREE.Vector3(0, 0, 0));
      }
      booleanSpace = 0;
    });

    scene.add(paperSphere);
}
