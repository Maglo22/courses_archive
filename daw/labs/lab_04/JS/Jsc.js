//--- tabla ---
var num = prompt("Introduce un número límite");
var myTable = "<table><tr><th>Número</th><th>Cuadrado</th><th>Cubo</th></tr>";

for (var i = 0; i < num; i++) {
    myTable += "<tr>";
    myTable += "<td>" + (i+1) + "</td>";
    myTable += "<td>" + Math.pow((i+1), 2) + "</td>";
    myTable += "<td>" + (Math.pow((i+1), 2) * (i+1)) + "</td>";
    myTable += "</tr>";
}
myTable += "</table>";
document.getElementById('tabla').innerHTML += myTable;

//--- suma ---
var s1 = Math.floor((Math.random() * 150) + 1);
var s2 = Math.floor((Math.random() * 150) + 1);
var t = new Date();
var t1 = t.getTime();
var r = prompt("¿Cuál es el resultado de " + s1 + " + " + s2 + "?");
var tf = new Date();
var t2 = tf.getTime();
var resC = s1 + s2;
var res;
if(r == resC){
    res = "Correcta";
}
else{
    res = "Incorrecta";
}
document.getElementById('suma').innerHTML += "<h4>Respuesta de " + s1 + " + " + s2 + ": " + resC +"</h4>";
document.getElementById('suma').innerHTML += "Tu respuesta fue: ";
document.getElementById('suma').innerHTML += r + ". " + res + "." + " Tardasre: " + ((t2-t1)/1000) + " segundos.";

//--- contador ---
var arr = new Array(10);
for (var i = 0; i < 10; i++){
    arr[i] = Math.floor((Math.random() * 100) - 50);
}
var neg = 0;
var zer = 0;
var pos = 0;

function counter(arreglo){
    for (var i = 0; i < 10; i++) {
        if(arreglo[i] < 0){
            neg++;
        }
        else if(arreglo[i] > 0){
            pos++;    
        }
        else{
            zer++;
        }
    }
    return;
}

counter(arr);
document.getElementById('contador').innerHTML += "Arreglo: " + arr;
document.getElementById('contador').innerHTML += "</br>Números negativos en el arreglo: " + neg;
document.getElementById('contador').innerHTML += "</br>Números positivos en el arreglo: " + pos;
document.getElementById('contador').innerHTML += "</br>Ceros en el arreglo: " + zer;

//--- promedios ---
//-- Creación de la matriz --
var mat = new Array(10);
for (var i = 0; i < 10; i++){
    mat[i] = new Array(10);
}
for (var i = 0; i< 10; i++){
    for (var j = 0; j < 10; j++){
        mat[i][j] = Math.floor((Math.random() * 100) + 10);
    }
}
//---------------------------------------------------------------
function promedio(matrix){
    var calcP = new Object();
    var suma;
    var temp;
    for (var i = 0; i < 10; i++){
        suma = 0;
        temp = 0;
        for (var j = 0; j < 10; j++){
            suma += matrix[i][j];
            temp = suma/10;
        }
        calcP[i] = temp;
    }
    return calcP;
}
var prom = promedio(mat);
for (var i = 0; i < 10; i++){
    document.getElementById('promedios').innerHTML += "</br>Fila " + (i+1) + ": " + prom[i];
}

//--- inverso ---
var n = Math.floor((Math.random() * 20000) + 101);

function inv(numero){
    str_num = numero.toString();
    var numIn = Number(str_num.split("").reverse().join(""));
    return numIn;
}
document.getElementById('inverso').innerHTML += "Número a invertir: " + n;
document.getElementById('inverso').innerHTML += "</br>Número invertido: " + inv(n);

//--- personal ---
var span = document.getElementById('span');
function time(){
    var d = new Date();
    var s = d.getSeconds();
    var m = d.getMinutes();
    var h = d.getHours();
    span.textContent = h + ": " + m + ": " + s;
}
setInterval(time, 1000);