//--password --
function validarForma() {
    var res = document.forms["valid"]["password"].value, res2 = document.forms["valid"]["Vpassword"].value;
    if (res == "" || res2 == "") {
        alert("Llenar ambos campos.");
        return false;
    } else if (res !== res2) {
        alert("Contraseñas deben coincidir.");
        return false;
    }
    alert("Contraseñas coinciden.");
    return true;
}

//-- Productos --
var proArr = [3000, 100, 999999999];
var carrito = 0;
function opCompra() {
    var list = document.getElementsByClassName("ntext"), temp = 0, iva = 0;
    for (var i = 0; i < list.length; i++){
        temp += (list[i].value * proArr[i]);
    }
    iva = temp * (.16);
    carrito = temp + iva;
    alert("Articulo agregado al carrito.");
    acCarrito();
}
function acCarrito() {
    document.getElementById("carrito").innerHTML = "Total: " + carrito + " (iva incluido)";
    return;
}
function compra() {
    let msg = "¿Pagar " + carrito + "?";
    confirm(msg);
    return;
}

//-- problema --
function change(elemt) {
    elemt.value = 1;
}
function check() {
    var points = 0;
    var enc = document.getElementsByName("en");
    for (var i = 0; i < enc.length; i++){
        if(enc[i].value == "1"){
            points++;
        }
    }
    alert("Obtuviste " + points + "/7 respuestas correctas");
}