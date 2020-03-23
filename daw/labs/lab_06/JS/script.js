//-- cambiar estilo de letra --
var bandera = false;
function cambiarLetra() {
    /*if(bandera == false) {
        document.getElementById("preguntas").style.font = "bold 1.5em geoorgia, serif";
        bandera = true;
    }
    else {
        document.getElementById("preguntas").style.font = "1em arial, sans-serif";
        bandera = false;
    }*/
    document.getElementById("preguntas").style.font = "bold 1.5em geoorgia, serif";
}

//-- Timers --
var cl = setInterval(reloj, 1000);
function oreloj() {
    document.getElementById("clock").style.visibility = "hidden";
}
function vreloj() {
    document.getElementById("clock").style.visibility = "visible";
}

function reloj() {
    var d = new Date();
    document.getElementById("clock").innerHTML = d.toLocaleTimeString();
}

//-- drag & drop --
function permitDrop(ev) {
    ev.preventDefault();
}
function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}
function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    ev.target.appendChild(document.getElementById(data));
}