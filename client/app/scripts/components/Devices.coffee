m = require 'mithril'
conf = require '../conf'
Message = require './Message'

module.exports = class Devices

  @view: () ->
    [
      m 'div', {class: 'devices'}, [
        m 'h2', 'Dispositvos'
        m 'p', m.trust "Siempre esta la página web. Después si desea instalar el buscador en su teléfono, tablet o escritorio tal vez hay algo aquí."
        m 'table', {class: 'pure-table'}, [
          m 'tbody', [
            row "<i class='fa fa-firefox fa-2x'></i> <i class='fa fa-safari fa-2x'></i> <i class='fa fa-chrome fa-2x'></i> <i class='fa fa-internet-explorer fa-2x'></i>", 'Abrir en un navegador como Firefox, Chrome, Safari, IE', 'http://ruc.sun.com.py'
            row "<img src='#{conf.imgPath}img/google-play-140x50.png'>", 'Descargar en Google Play para Android', 'https://play.google.com/store/apps/details?id=py.com.sun.ruc'
#            row "<img src='#{conf.imgPath}img/app-store-135x40.png'>", 'Descargar en Apple App Store para iOS', '#'
#            row "<i class='fa fa-desktop fa-4x'></i>", 'Descargar aquí para el escritorio', '#'
          ]
        ]
      ]
    ]

  row = (col1, col2, link) ->
    m 'tr', [
      m 'td', [
        m 'a', {href: link}, m.trust col1
      ]
      m 'td', [
        m 'a', {href: link}, m.trust col2
      ]
    ]
