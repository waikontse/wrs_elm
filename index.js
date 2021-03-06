'use strict';

function setup(firebase, app) {
  const database = firebase.database();

  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      loadRiders();
      loadRaces();
      loadResults();
    }
  });

  firebase.auth().signInAnonymously();
}

const config = require('./config');
firebase.initializeApp(config);

const Elm = require('./src/Main');
const app = Elm.Main.embed(document.getElementById('main'));

setup(firebase, app);

function loadRiders() {
  firebase.database().ref('/riders/').orderByChild('id').on('value', function(snapshot) {
    const val = snapshot.val();
    const arr = val ? Object.keys(val).
      map(function (key) {
        return Object.assign({
            key: key
          }, val[key]);
      }) : [];
    app.ports.infoForElm.send({
      tag: 'RidersLoaded',
      data: arr
    });
  });
}

function loadRaces() {
  firebase.database().ref('/races/').on('value', function(snapshot) {
    const val = snapshot.val();
    const arr = val ? Object.keys(val).
      map(function (key) {
        return Object.assign({
            key: key
          }, val[key]);
      }) : [];
    app.ports.infoForElm.send({
      tag: 'RacesLoaded',
      data: arr
    });
  });
}

function loadResults() {
  firebase.database().ref('/results/').on('value', function(snapshot) {
    const val = snapshot.val();
    const arr = val ? Object.keys(val).
      map(function (key) {
        return Object.assign({
            key: key
          }, val[key]);
      }) : [];
    app.ports.infoForElm.send({
      tag: 'ResultsLoaded',
      data: arr
    });
  });
}

function addRace(race) {
  const pushedRace = firebase.database().ref('/races/').push();
  pushedRace.set(race)
    .then(function () {
      app.ports.infoForElm.send({
        tag: 'RaceAdded',
        data: pushedRace.key
      });
    });
}

function addRider(rider) {
  const pushedRider = firebase.database().ref('/riders/').push();
  pushedRider.set(rider)
    .then(function () {
      app.ports.infoForElm.send({
        tag: 'RiderAdded',
        data: pushedRider.key
      });
    });
}

function addResult(result) {
  const pushedResult = firebase.database().ref('/results/').push();
  pushedResult.set(result)
    .then(function () {
      app.ports.infoForElm.send({
        tag: 'ResultAdded',
        data: {
          key: pushedResult.key,
          riderKey: result.riderKey,
          raceKey: result.raceKey,
          category: result.category,
          result: result.result,
          outfit: result.outfit
        }
      });
    });
}

app.ports.infoForOutside.subscribe(function (msg) {
  if (msg.tag === 'RiderAdd') {
    addRider(msg.data);
  } else if (msg.tag === 'RaceAdd') {
    addRace(msg.data);
  } else if (msg.tag === 'ResultAdd') {
    addResult(msg.data);
  } else {
    console.log('msg', msg);
  }
});
