////////////////////////////////////////////////////////////////////////////////
/*global THREE, document, window  */
var camera, scene, renderer;
var cameraControls;

var clock = new THREE.Clock();

function fillScene() {
	scene = new THREE.Scene();
	scene.fog = new THREE.Fog( 0x808080, 2000, 4000 );

	// LIGHTS

	scene.add( new THREE.AmbientLight( 0x222222 ) );

	var light = new THREE.DirectionalLight( 0xffffff, 0.7 );
	light.position.set( 200, 500, 500 );

	scene.add( light );

	light = new THREE.DirectionalLight( 0xffffff, 0.9 );
	light.position.set( -200, -100, -400 );

	scene.add( light );
;

//grid xz
 var gridXZ = new THREE.GridHelper(2000, 100);
 gridXZ.setColors( new THREE.Color(0xCCCCCC), new THREE.Color(0x888888) );
 scene.add(gridXZ);

 //axes
 var axes = new THREE.AxisHelper(150);
 axes.position.y = 1;
 scene.add(axes);

 drawBall();
}

function drawBall() {

	var cylinder;

	// Array of materials.
	var materialArray = [
		new THREE.MeshPhongMaterial({
			color: 0x5500DD,
			specular: 0xD1F5FD,
			shininess: 100 }),
		new THREE.MeshPhongMaterial({
			color: 0xA9A9A9,
			specular: 0xD1F5FD,
			shininess: 100 })
	];

	// Set up the cylinder geometry.
	var cylinderGeo = new THREE.CylinderGeometry( 3, 3, 500, 32 );

	for (var i = 0; i < 500; i++){

		// Create the cylinder object.
		cylinder = new THREE.Mesh(cylinderGeo, materialArray[i % materialArray.length]);

		/* // Untrasformed cylinder (pointing up)
		var untransformedCylinder = cylinder.clone();
		console.log("Untransformed cylinder matrix:")
		console.log(untransformedCylinder.matrix); // Look at the console
		scene.add(untransformedCylinder);
		*/

		/*
		Transformation (rotate) the cylinder by taking two points, finding
		the vector between them, and then rotating by the angle
		of that vector.
		*/
		var x = (Math.random() * 2) - 1; var y = (Math.random() * 2) -1; var z = (Math.random() * 2) - 1;

		// Diagonally-opposite corners.
		var maxCorner = new THREE.Vector3(x, y, z);
		var minCorner = new THREE.Vector3(-x, -y, -z);

		var cylAxis = new THREE.Vector3().subVectors( maxCorner, minCorner ); // Create a vector in the direction from minCorner to maxCorner.
		cylAxis.normalize(); // Normalize the axis.
		var theta = Math.acos( cylAxis.y ); // we can derive the angle by taking arccos of the y axis.

		var rotationAxis = new THREE.Vector3(x, y, z); // Rotation axis for the cylinder.
		rotationAxis.normalize(); // Normalize the axis.

		cylinder.matrixAutoUpdate = false; // Disable to have manual control of the rotation (using the matrix property).
		/*
		This is how we manually set the rotation for the matrix. makeRotationAxis()
		takes a vector representing a rotation axis and a value (in radians) representing
		the angle around that axis to rotate.
		*/
		cylinder.matrix.makeRotationAxis(rotationAxis, theta);

		/*console.log("Theta: " + theta);
		console.log("  cos: " + Math.cos(theta));
		console.log("  sin: " + Math.sin(theta));
		console.log("Cylinder matrix:")
		console.log(cylinder.matrix);*/
		
		scene.add( cylinder );
	}
}

function init() {
	var canvasWidth = 700;
	var canvasHeight = 500;
	var canvasRatio = canvasWidth / canvasHeight;

	// RENDERER
	renderer = new THREE.WebGLRenderer( { antialias: true } );

	renderer.gammaInput = true;
	renderer.gammaOutput = true;
	renderer.setSize(canvasWidth, canvasHeight);
	renderer.setClearColor( 0xAAAAAA, 1.0 );

	// CAMERA
	camera = new THREE.PerspectiveCamera( 45, canvasRatio, 1, 4000 );
	// CONTROLS
	cameraControls = new THREE.OrbitControls(camera, renderer.domElement);
	camera.position.set( -800, 600, 500);
	cameraControls.target.set(0,0,0);
}

function addToDOM() {
    var canvas = document.getElementById('canvas');
    canvas.appendChild(renderer.domElement);
}

function animate() {
	window.requestAnimationFrame(animate);
	render();
}

function render() {
	var delta = clock.getDelta();
	cameraControls.update(delta);
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