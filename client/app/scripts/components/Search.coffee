m = require 'mithril'
Message = require './Message'

module.exports = class Search

  @loadingRequest: (args) ->
    loading = document.getElementById("loading")
    loading.style.display = "block"
    console.log 'now request'
    m.request(args).then (value, err) ->
      loading.style.display = "none"
      value 

  SearchVM =
    term: ''
    result: {}
    extract: (xhr, xhrOptions) ->
      console.log 'result: ' + JSON.parse xhr.response
      SearchVM.result = JSON.parse xhr.response
    deserialize: (xhr, xhrOptions) -> xhr
    search: (controller) =>
      request =
        method: 'GET'
        url: "/api/ruc/#{SearchVM.term}"
#        config: @xhrConfig
        deserialize: SearchVM.deserialize
        extract: SearchVM.extract
      console.log 'search: ' + SearchVM.term
      @loadingRequest(request)
      
  @controller: () =>
    
    search: (e) =>
      e.preventDefault()
      console.log 'search'
      SearchVM.term = document.getElementById('search-field').value
      unless SearchVM.term
        return Message.error 'Tienes que buscar algo en la vida'
      SearchVM.search this
      
  @view: (ctrl) ->
    [ 
      m 'h2', m.trust "Buscar un RUC<br><small>en el Registro Único del Contribuyente de Paraguay</small>"
      m 'form', {class: 'pure-form2 pure-form-stacked2'}, [
        m 'input', {id: 'search-field', placeholder: 'RUC o contribuyente', value: SearchVM.term}
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

