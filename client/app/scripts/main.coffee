m = require 'mithril'
conf = require './conf'
menu = require './components/Menu'
message = require './components/Message'
search = require('./components/Search')

m.route.mode = "pathname"

m.module(document.getElementById("message"), {controller: message.controller, view: message.view})
m.module(document.getElementById("menu"), {controller: menu.controller, view: menu.view})

m.route document.getElementById("content"), "/",
  "/": search
  "/sobre": require('./components/Sobre')
  "/calcDV": require('./components/CalcDV')
  "/explicacion": require('./components/SearchExplanation')
  "/dispositivos": require('./components/Devices')
  
#hack: try to render on some android devices there is a timing problem 
window.setTimeout m.redraw, 200  