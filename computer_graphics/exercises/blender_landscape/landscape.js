////////////////////////////////////////////////////////////////////////////////
/*global THREE, document, window  */
var camera, scene, renderer;
var cameraControls;

var clock = new THREE.Clock();
var rotation = 0;

function fillScene() {
	scene = new THREE.Scene();

	// LIGHTS

	scene.add( new THREE.AmbientLight( 0x222222 ) );

	var light = new THREE.DirectionalLight( 0xffffff, 0.7 );
	light.position.set( 200, 500, 500 );

	scene.add( light );

	light = new THREE.DirectionalLight( 0xffffff, 0.9 );
	light.position.set( -200, -100, -400 );

	scene.add( light );

	//grid xz
	var gridXZ = new THREE.GridHelper(2000, 100, new THREE.Color(0xCCCCCC), new THREE.Color(0x888888));
	scene.add(gridXZ);

	//axes
	var axes = new THREE.AxisHelper(150);
	axes.position.y = 1;
	scene.add(axes);

	drawLandscape();
}

function drawLandscape() {

	var manager = new THREE.LoadingManager();
	manager.onProgress = function ( item, loaded, total ) {
		console.log( item, loaded, total );
	};

	var onProgress = function ( xhr ) {
		if ( xhr.lengthComputable ) {
			var percentComplete = xhr.loaded / xhr.total * 100;
			console.log( Math.round(percentComplete, 2) + '% downloaded' );
		}
	};
	var onError = function ( xhr ) {
	};


	loader = new THREE.OBJLoader( manager );
		loader.load( 'landscape.obj', function ( object ) {
			object.position.y = 200;
			scene.add( object );
		}, onProgress, onError );
}

function init() {
	var canvasWidth = 600;
	var canvasHeight = 400;
	var canvasRatio = canvasWidth / canvasHeight;

	// RENDERER
	renderer = new THREE.WebGLRenderer( { antialias: true } );
	renderer.gammaInput = true;
	renderer.gammaOutput = true;
	renderer.setSize(canvasWidth, canvasHeight);
	renderer.setClearColor( 0xAAAAAA, 1.0 );

	// CAMERA
	camera = new THREE.PerspectiveCamera( 80, canvasRatio, 1, 15000 );
	camera.position.set( -1000, 100, 900);

	// CONTROLS
	cameraControls = new THREE.OrbitControls(camera, renderer.domElement);
	cameraControls.target.set(0,480,0);
}

function addToDOM() {
    var canvas = document.getElementById('canvas');
    canvas.appendChild(renderer.domElement);
    console.log(canvas);
}

function animate() {
	window.requestAnimationFrame(animate);
	render();
}

function render() {
	var delta = clock.getDelta();

	cameraControls.update();
	renderer.render(scene, camera);
}

try {
  init();
  fillScene();
  addToDOM();
  animate();
} catch(error) {
    console.log("Your program encountered an unrecoverable error, can not draw on canvas. Error was:");
    console.log(error);
}
