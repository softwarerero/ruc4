m = require 'mithril'
Message = require './Message'

module.exports = class Search

  @loadingRequest: (args) ->
    loading = document.getElementById("loading")
    loading.style.display = "block"
    m.request(args).then (value, err) ->
      loading.style.display = "none"
      value 

  SearchVM =
    result: {}
    extract: (xhr, xhrOptions) ->
      console.log 'result: ' + JSON.parse xhr.response
      SearchVM.result = JSON.parse xhr.response
    deserialize: (xhr, xhrOptions) -> xhr
    search: (controller, query) =>
      request =
        method: 'GET'
        url: "http://localhost:3000/api/ruc/#{query}"
#        config: @xhrConfig
        deserialize: SearchVM.deserialize
        extract: SearchVM.extract
      console.log 'search: ' + query
      @loadingRequest(request)
      
  @controller: () =>
    
    search: (e) =>
      e.preventDefault()
      console.log 'search'
      query = document.getElementById('search-field').value
      unless query
        return Message.error 'Tienes que buscar algo en la vida'
      SearchVM.search this, query
      
  @view: (ctrl) ->
    [ 
      m 'h2', m.trust " Buscar un RUC<br><small>en el Registro Único del Contribuyente de Paraguay</small>"
      m 'form', {class: 'pure-form2 pure-form-stacked2'}, [
        m 'input', {id: 'search-field', placeholder: 'RUC o contribuyente'}
        m 'button', {onclick: ctrl.search, class: 'search'}, [
          m 'i', {class: 'fa fa-search'}          
        ]
      ]
      if SearchVM.result.hits
        m 'div', {id: 'search-result'}, [
          m 'table', {class: 'pure-table pure-table-horizontal pure-table-striped'}, [
            m 'thead', [
              m 'tr', [
                m 'th', 'RUC'
                m 'th', 'Contribuyente'
                m 'th', 'DV'
              ]
            ]
            m 'tbody', [
              SearchVM.result.hits.map (hit) ->
                m 'tr', [
                  m 'td', hit.ruc
                  m 'td', hit.contribuyente
                  m 'td', hit.dv 
                ]
              ]
            ]
          m 'div', {class: 'small'}, "Encontrado: #{SearchVM.result.total} (solo se muestra los primeros 10)"
        ]
    ]

