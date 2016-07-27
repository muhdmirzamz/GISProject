// IT3161-GEOSPATIAL VISUALIZATION
// HeatMap Feature
// Foong Jun Hui 142855L
// heatmap.html, heatmap.css, heatmap.js
var map, heatmap;
var locationArr = new Array();
var zoom = 17;
var radius = 30;
var gradient = [
  'rgba(0, 0, 0, 0)',
  'rgba(0, 0, 0, 0.4)',
  'rgba(0, 0, 0, 0.6)',
  'rgba(0, 0, 0, 0.8)',
  'rgba(0, 0, 0, 1)',
  'rgba(0, 0, 0, 1)',
  'rgba(0, 0, 0, 1)'
]
//
// Electric
//
function initElectricMap() {
  locationArr = new Array();

  firebase.database().ref('/PreviousLocation/electric').once('value').then(function(snapshot) {
    snapshot.forEach(function(childSnapshot) {
      var key = childSnapshot.key;
      console.log("electric " + "Latitude: " + childSnapshot.val().latitude);
      console.log("electric " + "Longitude: " + childSnapshot.val().longitude);
      locationArr.push(new google.maps.LatLng(childSnapshot.val().latitude, childSnapshot.val().longitude));
    })

    map = new google.maps.Map(document.getElementById('map'), {
      zoom: zoom,
      center: {lat: 1.3801, lng: 103.8490},
      mapTypeId: google.maps.MapTypeId.MAP,
      disableDefaultUI: true
    });

    heatmap = new google.maps.visualization.HeatmapLayer({
      data: locationArr,
      map: map,
    });

    heatmap.set('radius', radius);
    heatmap.set('gradient', gradient);
    var $toastMsg = $('<span>Showing <b style="color:#FFEB3B;">Electric</b> type monster spawns</span>');
    Materialize.toast($toastMsg, 2000);
    $('.button-collapse').sideNav('hide');
  });
}

//
// Fire
//
function initFireMap() {
  locationArr = new Array();
  firebase.database().ref('/PreviousLocation/fire').once('value').then(function(snapshot) {
    snapshot.forEach(function(childSnapshot) {
      var key = childSnapshot.key;
      console.log("fire " + "Latitude: " + childSnapshot.val().latitude);
      console.log("fire " + "Longitude: " + childSnapshot.val().longitude);
      locationArr.push(new google.maps.LatLng(childSnapshot.val().latitude, childSnapshot.val().longitude));
    })

    map = new google.maps.Map(document.getElementById('map'), {
      zoom: zoom,
      center: {lat: 1.3801, lng: 103.8490},
      mapTypeId: google.maps.MapTypeId.MAP,
      disableDefaultUI: true
    });

    heatmap = new google.maps.visualization.HeatmapLayer({
      data: locationArr,
      map: map
    });

    heatmap.set('radius', radius);
    heatmap.set('gradient', gradient);
    var $toastMsg = $('<span>Showing <b style="color:#F44336;">Fire</b> type monster spawns</span>');
    Materialize.toast($toastMsg, 2000);
    $('.button-collapse').sideNav('hide');
  });
}

//
// Ghost
//
function initGhostMap() {
  locationArr = new Array();
  firebase.database().ref('/PreviousLocation/ghost').once('value').then(function(snapshot) {
    snapshot.forEach(function(childSnapshot) {
      var key = childSnapshot.key;
      console.log("ghost " + "Latitude: " + childSnapshot.val().latitude);
      console.log("ghost " + "Longitude: " + childSnapshot.val().longitude);
      locationArr.push(new google.maps.LatLng(childSnapshot.val().latitude, childSnapshot.val().longitude));
    })

    map = new google.maps.Map(document.getElementById('map'), {
      zoom: zoom,
      center: {lat: 1.3801, lng: 103.8490},
      mapTypeId: google.maps.MapTypeId.MAP,
      disableDefaultUI: true
    });

    heatmap = new google.maps.visualization.HeatmapLayer({
      data: locationArr,
      map: map
    });

    heatmap.set('radius', radius);
    heatmap.set('gradient', gradient);
    var $toastMsg = $('<span>Showing <b style="color:#607D8B;">Ghost</b> type monster spawns</span>');
    Materialize.toast($toastMsg, 2000);
    $('.button-collapse').sideNav('hide');
  });
}

//
// Grass
//
function initGrassMap() {
  var map, heatmap;
  var locationArr = new Array();
  firebase.database().ref('/PreviousLocation/grass').once('value').then(function(snapshot) {
    snapshot.forEach(function(childSnapshot) {
      var key = childSnapshot.key;
      console.log("grass " + "Latitude: " + childSnapshot.val().latitude);
      console.log("grass " + "Longitude: " + childSnapshot.val().longitude);
      locationArr.push(new google.maps.LatLng(childSnapshot.val().latitude, childSnapshot.val().longitude));
    })

    map = new google.maps.Map(document.getElementById('map'), {
      zoom: zoom,
      center: {lat: 1.3801, lng: 103.8490},
      mapTypeId: google.maps.MapTypeId.MAP,
      disableDefaultUI: true
    });

    heatmap = new google.maps.visualization.HeatmapLayer({
      data: locationArr,
      map: map
    });

    heatmap.set('radius', radius);
    heatmap.set('gradient', gradient);
    var $toastMsg = $('<span>Showing <b style="color:#8BC34A;">Grass</b> type monster spawns</span>');
    Materialize.toast($toastMsg, 2000);
    $('.button-collapse').sideNav('hide');
  });
}

//
// Water
//
function initWaterMap() {
  var map, heatmap;
  var locationArr = new Array();
  firebase.database().ref('/PreviousLocation/water').once('value').then(function(snapshot) {
    snapshot.forEach(function(childSnapshot) {
      var key = childSnapshot.key;
      console.log("water " + "Latitude: " + childSnapshot.val().latitude);
      console.log("water " + "Longitude: " + childSnapshot.val().longitude);
      locationArr.push(new google.maps.LatLng(childSnapshot.val().latitude, childSnapshot.val().longitude));
    })

    map = new google.maps.Map(document.getElementById('map'), {
      zoom: zoom,
      center: {lat: 1.3801, lng: 103.8490},
      mapTypeId: google.maps.MapTypeId.MAP,
      disableDefaultUI: true
    });

    heatmap = new google.maps.visualization.HeatmapLayer({
      data: locationArr,
      map: map
    });

    heatmap.set('radius', radius);
    heatmap.set('gradient', gradient);
    var $toastMsg = $('<span>Showing <b style="color:#2196F3;">Water</b> type monster spawns</span>');
    Materialize.toast($toastMsg, 2000);
    $('.button-collapse').sideNav('hide');
  });
}
