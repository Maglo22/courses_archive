"use strict";

// Core variables
var canvas, context, imageBuffer;

var DEBUG = false; //whether to show debug messages
var EPSILON = 0.00001; //error margins

var scene, camera, surfaces, materials, lights, bounce_depth, shadow_bias;

// Classes --------------------------------------------------------------------
// Camera class
var Camera = function(eye, at, up, fovy, aspect) {
  this.eye = new THREE.Vector3().fromArray(eye);
  this.at = new THREE.Vector3().fromArray(at);
  this.up = new THREE.Vector3().fromArray(up);

  this.w = new THREE.Vector3().subVectors(this.eye, this.at).normalize(); // Backward vector
  this.u = new THREE.Vector3().crossVectors(this.up, this.w).normalize(); // Rightward vector
  this.v = new THREE.Vector3().crossVectors(this.w, this.u).normalize(); // Upward vector

  this.fovy = fovy;
  this.aspect = aspect;

  this.height = 2 * Math.tan(rad(this.fovy / 2.0));
  this.width = this.height * this.aspect;

  // Camera to World matrix
  this.cam_to_world = new THREE.Matrix4();
  this.cam_to_world.set(
    this.u.x, this.v.x, this.w.x, this.eye.x,
    this.u.y, this.v.y, this.w.y, this.eye.y,
    this.u.z, this.v.z, this.w.z, this.eye.z,
    0, 0, 0, 1
  );
};

// Ray class
var Ray = function(origin, direction) {
  this.t_low = 0.01;
  this.t_high = 100;
  this.origin = origin;
  this.direction = direction;
};

// Generic Light class
var Light = function(source, color) {
    this.source = source; // Ambient, Point, Directional
    this.color = color;
}

// Ambient light class extends from Light
var AmbientLight = function(source, color) {
    Light.call(this, source, color);
}

// Point light class extends from Light
var PointLight = function(source, color, position) {
    Light.call(this, source, color);
    this.position = new THREE.Vector3().fromArray(position);
}

// Directional light class extends from Light
var DirectionalLight = function(source, color, direction) {
    Light.call(this, source, color);
    this.direction = new THREE.Vector3().fromArray(direction).normalize().negate();
}

// Material class
var Material = function(name, shininess, ka, kd, ks, kr) {
    this.name = name;
    this.shininess = shininess;
    this.ka = ka;
    this.kd = kd;
    this.ks = ks;
    this.kr = kr;
}

// Generic Surface class
var Surface = function(name, material, shape, transforms) {
    this.name = name;
    this.material = material;
    this.shape = shape;
    this.transforms = new THREE.Matrix4(); // Transformation Matrix

    if(transforms) {
      for(var tr of transforms){ // For each transformation in json
        var x = tr[1][0]; var y = tr[1][1]; var z = [1][1]; // Get values from array in json
        // Check the type of transformation and apply it based on this
        if(tr[0] === "Translate") {
          this.transforms.multiply(new THREE.Matrix4().makeTranslation(x, y, z));
        } else if(tr[0] === "Rotate"){
          this.transforms.multiply(new THREE.Matrix4().makeRotationX(x))
          .multiply(new THREE.Matrix4().makeRotationY(y))
          .multiply(new THREE.Matrix4().makeRotationZ(z));
        } else if(tr[0] === "Scale"){
          this.transforms.multiply(new THREE.Matrix4().makeScale(x, y, z));
        }
      }
    }
}

// Class Sphere extends from Surface
var Sphere = function(name, material, shape, center, radius, transforms) {
    Surface.call(this, name, material, shape, transforms); // Super constructor
    this.center = new THREE.Vector3().fromArray(center);
    this.radius = radius;
}

// Class Triangle extends from Surface
var Triangle = function(name, material, shape, p1, p2, p3, transforms) {
    Surface.call(this, name, material, shape, transforms); // Super constructor
    this.p1 = new THREE.Vector3().fromArray(p1);
    this.p2 = new THREE.Vector3().fromArray(p2);
    this.p3 = new THREE.Vector3().fromArray(p3);
}

// Functions ------------------------------------------------------------------
Camera.prototype.rayCasting = function(x, y){
  // Corresponding pixel values in viewing plane (x, y)
  var u = (this.width * x / (canvas.width - 1)) - (this.width / 2.0);
  var v = (-this.height * y / (canvas.height - 1)) + (this.height / 2.0);

  var uu = this.u.clone().multiplyScalar(u); // Multiply u vector from camera by u value calculated for pixel
  var vv = this.v.clone().multiplyScalar(v); // Multiply v vector from camera by v value calculated for pixel
  var uu_vv = new THREE.Vector3().addVectors(uu, vv); // Sum of uu + vv

  var minusW = this.w.clone().multiplyScalar(-1); // Camera w vector in oposite direction

  var dir = new THREE.Vector3().addVectors(minusW, uu_vv).normalize(); // Direction of ray

  var ray = new Ray(this.eye, dir); // Create ray for pixel

  return ray;
};

// Returns if there is an intersection on a sphere
Sphere.prototype.intersects = function(ray){
  var ec = ray.origin.clone().sub(this.center); // Ray origin vector - shpere center vector
  var a = ray.direction.clone().dot(ray.direction); // Dot product between ray direction vector and itself
  var b = ray.direction.clone().multiplyScalar(-1).dot(ec); // Dot product between - ray direction vector and ec
  var c = ec.clone().dot(ec) - (this.radius * this.radius); // Dot product between ec and itself minus the radius squared

  var dis = b * b - (a * c); // calculate the discriminant

  // If discriminant is negative = no intersection
  if(dis < 0) {
    return null;
  }
  // Positive = intersection [two solutions: one for the ray entering and one for the ray leaving]
  var t = b + Math.sqrt(dis) / (-2 * a);
  if(t > 0){
    var intersection = ray.direction.clone().multiplyScalar(t).add(ray.origin);
    return intersection;
  }

  return null;
};

// Returns the normal of a given point
Sphere.prototype.normal = function(point) {
    return new THREE.Vector3().subVectors(point, this.center).normalize();
}

// Returns if there is an intersection on a triangle
// Moller - Trumbore. Doesn't require precomputation of plane intersection. [https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm]
Triangle.prototype.intersects = function(ray){
  var e1 = new THREE.Vector3().subVectors(this.p2, this.p1); // Vector created from vertices p2 - p1
  var e2 = new THREE.Vector3().subVectors(this.p3, this.p1); // Vector created from vertices p3 - p1
  var h = new THREE.Vector3().crossVectors(ray.direction, e2); // Cross vector betwwen the rays direction and e2

  var a = e1.dot(h);
  // Check if ray is parallel to the triangle
  if(a > -EPSILON && a < EPSILON) {
    return null;
  }

  var f = 1.0/a;
  var s = new THREE.Vector3().subVectors(ray.direction, this.p1);
  var u = f * (s.dot(h));
  if(u < 0.0 || u > 1.0) {
    return null;
  }

  var q = new THREE.Vector3().crossVectors(s, e1);
  var v = f * (ray.direction.dot(q));
  if(v < 0.0 || u + v > 1.0) {
    return null;
  }

  var t = f * e2.dot(q);
  // Ray intersects
  if(t > EPSILON) {
    var intersection = ray.direction.clone().multiplyScalar(t).add(ray.origin);
    return intersection;
  } else {
    // There is a line intersection, but not a ray intersection
    return null;
  }
};

// Returns a normal of a given point
Triangle.prototype.normal = function(point) {
    var e1 = new THREE.Vector3().subVectors(this.p3, this.p1);
    var e2 = new THREE.Vector3().subVectors(this.p2, this.p1);

    return new THREE.Vector3().crossVectors(e1, e2).normalize();
}

// Gets direction of light of given point (for Point lights)
PointLight.prototype.getDirection = function(point) {
    return new THREE.Vector3().subVectors(this.position, point).normalize();
}

// Gets direction of light
DirectionalLight.prototype.getDirection = function(point) {
    return this.direction;
}

// Setup functions -------------------------------------------------------------

// Set up the surfaces on the scene
function setUpSurfaces(scene){
  surfaces = []; // Array of surfaces

  for (var i = 0; i < scene.surfaces.length; i++) {
    var surface = scene.surfaces[i]; // current surface
    if(surface.shape === "Sphere") {
      // Create and add Sphere to array
      surfaces.push(new Sphere(surface.name, surface.material,
        surface.shape, surface.center, surface.radius, surface.transforms));
    } else if(surface.shape === "Triangle") {
      // Create and add Triangle to array
      surfaces.push(new Triangle(surface.name, surface.material,
        surface.shape, surface.p1, surface.p2, surface.p3, surface.transforms));
    }
  }
}

// Set up the lights on the scene
function setUpLights(scene) {
  lights = []; // Array of lights

  for (var light of scene.lights) {
    if (light.source === "Ambient") {
      // Create and add Ambient light to array
      lights.push(new AmbientLight(light.source, light.color));
    } else if (light.source === "Point") {
      // Create and add Point light to array
      lights.push(new PointLight(light.source, light.color, light.position));
    } else if (light.source === "Directional") {
      // Create and add Directional light to array
      lights.push(new DirectionalLight(light.source, light.color, light.direction));
    }
  }
}

// Set up materials from surfaces on the scene
function setUpMaterials(scene) {
  materials = []; // Array of materials

  for (var material of scene.materials) {
    // Create and add Material to array
      materials.push(new Material(material.name, material.shininess,
        material.ka, material.kd, material.ks, material.kr));
  }
}


// Initializes the canvas and drawing buffers
function init() {
  canvas = $('#canvas')[0];
  context = canvas.getContext("2d");
  imageBuffer = context.createImageData(canvas.width, canvas.height); //buffer for pixels

  loadSceneFile("assets/SphereTest.json");
}

// loads and "parses" the scene file at the given path
function loadSceneFile(filepath) {
  scene = Utils.loadJSON(filepath); //load the scene

  // Set up camera
  camera = new Camera(scene.camera.eye, scene.camera.at, scene.camera.up,
    scene.camera.fovy, scene.camera.aspect);

  bounce_depth = scene.bounce_depth;
  shadow_bias = scene.shadow_bias;

  setUpSurfaces(scene); // Set up surfaces
  setUpLights(scene); // Set up lights
  setUpMaterials(scene); // Set up Materials

  render();
}

// Render functions ------------------------------------------------------------

// Renders the scene
function render() {
  var start = Date.now(); //for logging

  // For each pixel
  for (var x = 0; x < canvas.width; x++) {
    for (var y = 0; y < canvas.height; y++) {
      renderPixel(x, y);
    }
  }

  context.putImageData(imageBuffer,0,0); // render the pixels that have been set
  var end = Date.now(); //for logging
  $('#log').html("rendered in: " + (end-start) + "ms");
  console.log("rendered in: " + (end-start) + "ms");
}

// Fire ray and get color
function renderPixel(x, y) {
    var ray = camera.rayCasting(x, y); // cast the ray
    var color = rayColor(ray, 0); // get its color value
    setPixel(x, y, color);
}

// Returns the color of the ray
function rayColor(ray, depth) {
  const black = [0, 0, 0];
  if(depth > bounce_depth) {
    return;
  }

  var closest = closestSurface(ray);
  if (closest.surface === null) {
    return black;
  }

  var surface = closest.surface;
  var intersection = closest.intersection;
  var material = materials[surface.material];

  var R = 0, G = 0, B = 0;

  for (var light of lights) {
    // Ambient light
    if (light instanceof AmbientLight) {
      // Shading Calculation
      var aR = material.ka[0] * light.color[0];
      var aG = material.ka[1] * light.color[1];
      var aB = material.ka[2] * light.color[2];

      R = R + aR; G = G + aG; B = B + aB; // Set the RGB values
    } else {
      // Point or Directional light
      var lightDirection = light.getDirection(intersection);
      var normal = surface.normal(intersection);

      var lightRay = {
        "origin": new THREE.Vector3().copy(normal).multiplyScalar(shadow_bias).add(intersection),
        "direction": lightDirection
      };

      var shadow = closestSurface(lightRay);
      if(shadow.surface === null) {
        var h = new THREE.Vector3().copy(ray.direction).negate().add(lightDirection).normalize();

        // Shading Calculation
        var dR = material.kd[0] * light.color[0] * Math.max(0, normal.dot(lightDirection));
        var dG = material.kd[1] * light.color[1] * Math.max(0, normal.dot(lightDirection));
        var dB = material.kd[2] * light.color[2] * Math.max(0, normal.dot(lightDirection));

        var p = material.shininess;
        var kR = material.ks[0] * light.color[0] * Math.pow(Math.max(0, normal.dot(h)), p);
        var kG = material.ks[1] * light.color[1] * Math.pow(Math.max(0, normal.dot(h)), p);
        var kB = material.ks[2] * light.color[2] * Math.pow(Math.max(0, normal.dot(h)), p);

        R = R + dR + kR; G = G + dG + kG; B = B + dB + kB; // Set the RGB values
      }
    }
  }

  return [R, G, B];
}

// Returns the closest surface to the ray
function closestSurface(ray) {
    var surface = null;
    var intersection = null;
    var distance = Infinity;

    for (var sur  of surfaces) { // curernt surface
        var inter = sur.intersects(ray); // current intersection
        if(inter === null) {
          continue;
        }

        var dis = (ray.origin).distanceTo(inter); // current distance
        if (0 < dis && dis < distance) {
            surface = sur;
            intersection = inter;
            distance = dis;
        }
    }
    return {
        "surface": surface,
        "intersection": intersection,
        "distance": distance
    };
}


//sets the pixel at the given x,y to the given color
/**
 * Sets the pixel at the given screen coordinates to the given color
 * @param {int} x     The x-coordinate of the pixel
 * @param {int} y     The y-coordinate of the pixel
 * @param {float[3]} color A length-3 array (or a vec3) representing the color. Color values should floating point values between 0 and 1
 */
function setPixel(x, y, color){
  var i = (y*imageBuffer.width + x)*4;
  imageBuffer.data[i] = (color[0]*255) | 0;
  imageBuffer.data[i+1] = (color[1]*255) | 0;
  imageBuffer.data[i+2] = (color[2]*255) | 0;
  imageBuffer.data[i+3] = 255; //(color[3]*255) | 0; //switch to include transparency
}

// Converts degrees to radians
function rad(degrees){
  return degrees * Math.PI/180;
}

// Run the application
$(document).ready(function(){
  init();
  render();

  // load and render new scene
  $('#load_scene_button').click(function(){
    var filepath = 'assets/' + $('#scene_file_input').val() + '.json';
    loadSceneFile(filepath);
  });

  //debugging - cast a ray through the clicked pixel with DEBUG messaging on
  $('#canvas').click(function(e){
    var x = e.pageX - $('#canvas').offset().left;
    var y = e.pageY - $('#canvas').offset().top;
    DEBUG = true;
    camera.rayCasting(x, y); // cast a ray through the point
    DEBUG = false;
  });
});
