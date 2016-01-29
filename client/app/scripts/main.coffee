m = require 'mithril'
conf = require './conf'
menu = require './components/Menu'
message = require './components/Message'

m.module(document.getElementById("message"), {controller: message.controller, view: message.view})
m.module(document.getElementById("menu"), {controller: menu.controller, view: menu.view})

m.route document.getElementById("content"), "/",
  "/": require('./components/Search')
  "/sobre": require('./components/Sobre')
  "/calcDV": require('./components/CalcDV')
  "/explicacion": require('./components/SearchExplanation')
  
 