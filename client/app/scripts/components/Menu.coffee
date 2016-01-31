m = require 'mithril'

module.exports = class Menu

  @controller = () ->

  @view = () ->
  
    return m "div", {class: 'pure-menu pure-menu-horizontal'},
      m 'ul', {class: 'pure-menu-list'}, [
        m 'li', {class: 'pure-menu-item'}, [
          m 'a', {class: 'pure-menu-link', href: '/', config: m.route}, [
            m 'i', {class: 'fa fa-search'}
            m 'span', ' Buscador'
          ]
        ]
        m 'li', {class: 'pure-menu-item pure-menu-has-children pure-menu-allow-hover'}, [
          m 'a', {class: 'pure-menu-link', href: '/sobre', config: m.route}, [
            m 'i', {class: 'fa fa-info'}
            m 'span', ' Información'
          ]
          m 'ul', {class: 'pure-menu-children'}, [
            mlink '/explicacion', 'Manual de búsqueda'
            mlink '/calcDV', 'Calcular DV (Algoritmos)'
            mlink '/sobre', 'Sobre'
          ]
        ]
      ]
 
  
  mlink = (href, txt) -> 
    [m 'li', {class: 'pure-menu-item'}, m 'a[href="' + href + '"]', {config: m.route, class: 'pure-menu-link'}, txt]
