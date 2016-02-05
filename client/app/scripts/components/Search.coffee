m = require 'mithril'
Message = require './Message'

module.exports = class Search

  @loadingRequest: (args) ->
    loading = document.getElementById("loading")
    loading.style.display = "block"
    m.request(args).then (value, err) ->
      loading.style.display = "none"
      value

#  navigator.userAgent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:44.0) Gecko/20100101 Firefox/44.0
#  navigator.userAgent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13B137 (2098465040)
#  @isMobile: -> navigator.userAgent.indexOf('Mobile') > -1
#  @domain: -> if @isMobile() then 'http://ruc4.sun.com.py' else ''
  @domain: -> if location.host then "http://#{location.host}" else 'http://ruc.sun.com.py'
#  @domain: -> ''
#http://localhost:4000/api/ruc/t
  
  SearchVM =
    term: ''
    result: {}
    extract: (xhr, xhrOptions) ->
      SearchVM.result = JSON.parse xhr.response
    deserialize: (xhr, xhrOptions) -> xhr
    search: (controller) =>
#      console.log "#{@domain()}/api/ruc/#{SearchVM.term}"
      request =
        method: 'GET'
        url: "#{@domain()}/api/ruc/#{SearchVM.term}"
#        config: @xhrConfig
        deserialize: SearchVM.deserialize
        extract: SearchVM.extract
      @loadingRequest(request)
      
  @controller: () =>
    
    search: (e) =>
      e.preventDefault()
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

