var scene;
var camera;
var circleGeometry = new THREE.Geometry();
initializeScene();
renderScene();


function initializeScene(){
  if(Detector.webgl){
    renderer = new THREE.WebGLRenderer( { antialias: true} );
  }else{
    renderer = new THREE.CanvasRenderer();
  }

  renderer.setClearColor(0x000000, 1);

  canvasWidth = 600;
  canvasHeight = 400;

  renderer.setSize(canvasWidth, canvasHeight);

  document.getElementById("canvas").appendChild(renderer.domElement);

  scene = new THREE.Scene();

  camera = new THREE.PerspectiveCamera(45, canvasWidth/canvasHeight, 1, 100);
  camera.position.set(0, 0, 10);
  camera.lookAt(scene.position);

  scene.add(camera);

  for(var i = 0; i <= 360; i = i + 9){
    var d = i * Math.PI / 180; // angle in degrees.

    // 10
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d), Math.cos(d), 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 9, 10);
    }

    //11
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*2, Math.cos(d)*2, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //12
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*3, Math.cos(d)*3, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //13
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*4, Math.cos(d)*4, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //14
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*5, Math.cos(d)*5, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //15
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*6, Math.cos(d)*6, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //16
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*7, Math.cos(d)*7, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //17
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*8, Math.cos(d)*8, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 2, 10);
      faces(1, 9, 10);
    }

    //18
    circleGeometry.vertices.push(new THREE.Vector3(Math.sin(d)*9, Math.cos(d)*9, 0));
    if(circleGeometry.vertices.length > 9){
      faces(1, 10, 11);
    }
  }

  var circleMaterial = new THREE.MeshBasicMaterial({
    vertexColors:THREE.VertexColors,
    side:THREE.DoubleSide,
    wireframe: true
  });

  var circleMesh = new THREE.Mesh(circleGeometry, circleMaterial);

  scene.add(circleMesh);
}

function faces(a, b, c){
  circleGeometry.faces.push(new THREE.Face3(
    circleGeometry.vertices.length - a,
    circleGeometry.vertices.length - b,
    circleGeometry.vertices.length - c));

  circleGeometry.faces[circleGeometry.faces.length - 1].vertexColors[0] = new THREE.Color(0xFF0000);
  circleGeometry.faces[circleGeometry.faces.length - 1].vertexColors[1] = new THREE.Color(0x00FF00);
  circleGeometry.faces[circleGeometry.faces.length - 1].vertexColors[2] = new THREE.Color(0x0000FF);
}


function renderScene(){
  renderer.render(scene, camera);
}
