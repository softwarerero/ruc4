m = require 'mithril'

module.exports = class SearchExplanation

  @controller: () =>


  @view: (ctrl) ->
    [
      m 'h2', m.trust "Como buscar?"
      m 'p', m.trust "Normalmente el buscador encuentra todo lo que empieza con el termino insertado, 
        pero hay todo un pequeño idioma para hacer busquedas más avanzadas. La documentación esta 
        disponible en inglés <a href='https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-string-syntax'>aquí</a>."
      m 'p', m.trust "Por defecto el buscador añade automáticamente un '*' el termino insertado si este no
        incluye un carácter en blanco. También esta trancado todo a partir del primer '-', eso es porque
        mucha gente entra el dígito verificador separado por un '-' y así no va a encontrar nada." 
    ]

