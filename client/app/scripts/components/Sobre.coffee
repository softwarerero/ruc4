m = require 'mithril'
Message = require './Message'

module.exports = class Sobre

  @controller: () =>

    search: (e) =>
      e.preventDefault()


  @view: (ctrl) ->
    [
      m 'h2', 'Sobre el Buscador de RUC'
      m 'p', {style: ''}, m.trust 'SUNCOM RUC es un pequeño buscador para encontrar un RUC en el <strong>Registro Único del Contribuyente de Paraguay</strong>.'
      m 'img', {src: '/img/ruc.png', style: ''}
      m 'h4', 'Utilizamos las sigientes herramientas y damos gracias a sus desarrolladores:'
      m 'p', m.trust 'CoffeeScript, Elasticsearch, Mithril, Node, Express, Gulp, Browserify, Pure, Fontawesome'
      m 'table', {class: 'pure-table'}, [
        m 'thead', [
          m 'tr', [
            m 'th', 'Versión'
            m 'th', 'Fecha'
            m 'th', 'Novedades'
          ]
        ]
        m 'tbody', [
          row '4.0', '01.02.2016', 'Portado a CoffeeScript, Node.js y Mithril'
          row '1.1.2', '20.11.2013', 'Diseño fluido con Bootstrap 3 y Jade'
          row '1.1.1 ', '06.02.2013', 'Actualización a Play Framework 2.1.0'
          row '1.1.0', '17.12.2012', 'Hackathon Asunción: Portado a Play Framework'
          row '1.0.2', '14.12.2012', 'Update to Xitrium 1.11 with Hazelcast 2.4, tuneo del logotipo'
          row '1.0.1', '09.11.2012', 'Cambio del motor de búsqueda de Lucene a elasticsearch'
          row '1.0', '25.10.2012', 'Buscar en el registro único del contribuyente con numero de ruc o nombre'
        ]
      ] 
    ]

  row = (version, date, text) ->
    m 'tr', [
      m 'td', version
      m 'td', date
      m 'td', text
    ]
