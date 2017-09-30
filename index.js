'use strict';

function setup(firebase, app) {
  var database = firebase.database();

  firebase.auth().onAuthStateChanged(function(user) {
    if (user) {
      console.log('user changed to logged in');
      app.ports.login.send(user.email);
      /*
      firebase.database().ref('/riders/').once('value').then(function(snapshot) {
        console.log('snapshot', snapshot.val());
      });
      */
    } else {
      console.log('no user signed in');
    }
  });
}

var config = {
  apiKey: "AIzaSyCCzStZqMSpKAnBaSNK1MNlaleBTR9b-dA",
  authDomain: "cycling-results.firebaseapp.com",
  databaseURL: "https://cycling-results.firebaseio.com",
  projectId: "cycling-results",
  storageBucket: "cycling-results.appspot.com",
  messagingSenderId: "939143658590"
};
firebase.initializeApp(config);

var Elm = require('./src/Main');
var app = Elm.Main.embed(document.getElementById('main'), { });

setup(firebase, app);

app.ports.getLocalStorage.subscribe(function (key) {
  return localStorage.getItem(key);
});

app.ports.setLocalStorage.subscribe(function (tuple) {
  return localStorage.setItem(tuple[0], tuple[1]);
});

app.ports.accountLogin.subscribe(function(account) {
  firebase.auth().signInWithEmailAndPassword(account.email, account.password).then(function(user) {
    console.log('signed in correctly');
  }).catch(function(error) {
    console.log('error', error);
  });
});

app.ports.accountLogout.subscribe(function() {
  console.log('logout');
  firebase.auth().signOut().then(function() {
    app.ports.logout.send('logouted');
  });
});
