/*
  File in charge of initializing the scene and the main loop to start the game
*/

'use strict';

// Physijs initialization
Physijs.scripts.worker = './plugins/physics/physijs_worker.js'; // path relative to html file
Physijs.scripts.ammo = 'ammo.js'; // path relative to physi.js

// blender objects
var paperballObj, trashcanObj;

// spawns a Box with physics enabled
function spawnBox(){
    // Box with physics
    var box = new Physijs.BoxMesh(
      new THREE.CubeGeometry( .5, .5, .5 ),
      new THREE.MeshBasicMaterial({ color: 0xffffff, wireframe:true })
    );
    box.addEventListener( 'collision', function( other_object, linear_velocity, angular_velocity ) {
      // `this` is the mesh with the event listener. other_object is the object `this` collided with. linear_velocity and angular_velocity are Vector3 objects which represent the velocity of the collision
      console.log("Box collided");
    });
    box.position.y = 10;
    box.position.z =  Math.floor((Math.random() * 2) + .5);
    box.rotateX(rad(30));
    scene.add( box );
}

// spawns a sphere with physics enabled
function spawnSphere(){
    var sphere = new Physijs.SphereMesh(
      new THREE.SphereGeometry( .3, 10, 10 ),
      new THREE.MeshBasicMaterial({ color: 0xffffff, wireframe:true })
    );
    sphere.position.y = Math.floor((Math.random() * 20) + 14);
    sphere.position.z = Math.floor((Math.random() * 5));
    sphere.position.x = Math.floor((Math.random() * 3));

    scene.add(sphere);
}

// initialize scene
function init() {
    // renderer
    renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.shadowMap.enabled = true;
    renderer.shadowMapSoft = true;
    renderer.setSize( window.innerWidth, window.innerHeight );
    renderer.setClearColor( 0x889988 );

    // scene
    scene = new Physijs.Scene;
    scene.setGravity(new THREE.Vector3( 0, -20, 0 ));

    // cameras
    camera = new THREE.PerspectiveCamera( 35, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.set( 0, 5, -5 );
    scene.add(camera); // required, since adding light as child of camera

    cameraTop = new THREE.PerspectiveCamera( 35, window.innerWidth / window.innerHeight, 1, 1000 );
    cameraTop.position.set( 0, 15, 2 );
    cameraTop.lookAt(0,0,5);
    scene.add(cameraTop); // required, since adding light as child of camera
    
    cameraTrash = new THREE.PerspectiveCamera( 35, window.innerWidth / window.innerHeight, 1, 1000 );
    cameraTrash.position.set(-0.28,2,10.5);
    cameraTrash.lookAt(0,3,0);
    scene.add(cameraTrash); // required, since adding light as child of camera
    
    // raycaster
    raycaster = new THREE.Raycaster();

    // controls
    controls = new THREE.OrbitControls( camera );
    controls.enableZoom = false;
    controls.enablePan = false;
    controls.maxPolarAngle = Math.PI / 2;

    // ambient
    scene.add( new THREE.AmbientLight( 0x444444 ) );

    // light
    var light = new THREE.PointLight( 0xffffff, 0.8 );
    camera.add(light);

    drawRoom();
    drawObjects();
    
    // Ball selection buttons
    document.getElementById("paperBallBtn").addEventListener('click', function (event) {
      event.preventDefault();
      ballSelection = 1;
    });
    
    document.getElementById("lightBallBtn").addEventListener('click', function (event) {
      event.preventDefault();
      ballSelection = 2;
    });
    
    document.getElementById("bowlingBall").addEventListener('click', function (event) {
      event.preventDefault();
      ballSelection = 3;
    });
    
    // View selection buttons
    document.getElementById("normalViewBtn").addEventListener('click', function (event) {
      event.preventDefault();
      cameraSelection = 1;
    });
    
    document.getElementById("topViewBtn").addEventListener('click', function (event) {
      event.preventDefault();
      cameraSelection = 2;
    });
    
    document.getElementById("trashViewBtn").addEventListener('click', function (event) {
      event.preventDefault();
      cameraSelection = 3;
    });
    
    // Start game button
    document.getElementById("playBtn").addEventListener('click', function (event) {
      event.preventDefault();
      start();
    });
}

function start(){
    drawBall();
    document.getElementById("menu").style.display = "none";
    document.getElementById("views").style.visibility = "visible";
    document.getElementById("balls").style.visibility = "hidden";
	var points = document.getElementById("points");
    booleanSpace = 0;
	points.style.display = "block";
}

// add scene to html file
function addToDOM() {
    document.body.appendChild( renderer.domElement );
}

// animation loop
function animate() {
    window.requestAnimationFrame(animate);
    // check for keyboard input
    keyboard.update();
    keyInput();

    if(percentComplete == 100) {
        ironMan.rotation.y = Date.now()*.0005;
    }

    paperSphere.__dirtyPosition = true;
    paperSphere.__dirtyRotation = true;

    render();
}

// render loop
function render() {
    switch(cameraSelection) {
        case 2:
            renderer.render(scene, cameraTop);
            break;
        case 3:
            renderer.render(scene, cameraTrash);
            break;
        default:
            renderer.render(scene, camera);
    }
    scene.simulate(); // physics simulation
}

try {
    init();
    addToDOM();
    animate();
} catch(error) {
    console.log("Your program encountered an unrecoverable error, can not draw on canvas. Error was:");
    console.log(error);
}
