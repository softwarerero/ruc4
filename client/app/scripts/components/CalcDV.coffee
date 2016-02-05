m = require 'mithril'
conf =  require '../conf'
Message = require './Message'

module.exports = class CalcDV

  @controller: () =>

    search: (e) =>
      e.preventDefault()


  @view: (ctrl) ->
    [
      m 'h2', 'Como calcular el Codigo Verificador del RUC?'
      m 'p', {style: ''}, m.trust 'En la <a href="http://www.set.gov.py/portal/PARAGUAY-SET/detail?content-id=/repository/collaboration/sites/PARAGUAY-SET/documents/herramientas/digito-verificador.pdf">
                    página del SET</a> existen funciones para calcular el dígito verificador del RUC (GUIÓN) en PL/SQL, Visual Basic y C.
                  p Aqui publicamos los algoritmos en <strong>JavaScript, CoffeeScript, Scala, Groovy y Java.</strong>'

      m 'h4', m.trust 'JavaScript'
      m 'pre[style="white-space:pre"]', m.trust 'function calcDv(ruc) {
      \n\tvar i, it, k, numero_aux, resto, total;
      \n\tk = 2;
      \n\ttotal = 0;
      \n\truc = parseInt(ruc).toString().split("");
      \n\tfor (i = ruc.length - 1; i >= 0; i += -1) {
      \n\t  it = ruc[i];
      \n\t  numero_aux = it.charCodeAt(0) - 48;
      \n\t  k = k > 11 ? 2 : k;
      \n\t  total += numero_aux * k++;
      \n\t}
      \n\tresto = total % 11;
      \n\tif (resto > 1) {
      \n\t  return 11 - resto;
      \n\t} else {
      \n\t  return 0;
      \n\t}
      \n};'

      m 'h4', m.trust 'CoffeeScript'
      m 'pre[style="white-space:pre"]', m.trust 'calcDv = (ruc) ->
              \n\tk = 2; total = 0
              \n\truc = parseInt(ruc).toString().split ""
              \n\tfor it in ruc by -1
              \n\t  numero_aux = it.charCodeAt(0) - 48
              \n\t  k = if k > 11 then 2 else k
              \n\t  total += numero_aux * k++
              \n\tresto = total % 11
              \n\tif resto > 1 then 11 - resto else 0'

      m 'h4', m.trust 'Scala <small>(No tan idiomático, yo se)</small>'
      m 'pre[style="white-space:pre"]', m.trust 'def calcDV(ruc: String, basemax: Int = 11) = {
        \n\tval numeroRuc = ruc.map(it =&gt; if (it.isDigit) it.asDigit else it).mkString.reverse
        \n\t
        \n\tvar k = 2
        \n\tvar v_total = 0
        \n\t
        \n\tfor (n &lt;- numeroRuc) {
        \n\t  k = if (k &gt; basemax) 2 else k
        \n\t  v_total += (n - 48) * k
        \n\t  k += 1
        \n\t}
        \n\t    
        \n\tval v_resto = v_total % 11
        \n\tval v_digit = if (v_resto &gt; 1) 11 - v_resto else 0
        \n\t
        \n\tv_digit.toString
      \n}'

      m 'h4', m.trust 'Groovy'
      m 'pre[style="white-space:pre"]', m.trust 'int calcDigitoVerificador(String ruc, int basemax = 11) {
      \n\t  String numeroRuc = ruc.chars.collect {
      \n\t    it.isDigit() ? it : (int) it
      \n\t  }.join()
      \n\t      
      \n\t  int k = 2
      \n\t  int total = 0
      \n\t  numeroRuc.reverse().chars.each {
      \n\t    k = k &gt; basemax ? 2 : k
      \n\t    int numero_aux = it - 48
      \n\t    total += numero_aux * k++
      \n\t  }
      \n\t      
      \n\t  int resto = total % 11
      \n\t  resto &gt; 1 ? 11 - resto : 0
      \n\t}'

      m 'h4', m.trust 'Java'
      m 'pre[style="white-space:pre"]', m.trust 'int Pa_Calcular_Dv_11_A(String p_numero, int p_basemax) {
      \n\t  int v_total, v_resto, k, v_numero_aux, v_digit;
      \n\t  String v_numero_al = "";
      \n\t      
      \n\t  for (int i = 0; i &lt; p_numero.length(); i++) {
      \n\t    char c = p_numero.charAt(i);
      \n\t    if(Character.isDigit(c)) {
      \n\t      v_numero_al += c;
      \n\t    } else {
      \n\t      v_numero_al += (int) c;
      \n\t    }
      \n\t  }
      \n\t      
      \n\t  k = 2;
      \n\t  v_total = 0;
      \n\t      
      \n\t  for(int i = v_numero_al.length() - 1; i &gt;= 0; i--) {
      \n\t    k = k &gt; p_basemax ? 2 : k;
      \n\t    v_numero_aux = v_numero_al.charAt(i) - 48;
      \n\t    v_total += v_numero_aux * k++;
      \n\t  }
      \n\t      
      \n\t  v_resto = v_total % 11;
      \n\t  v_digit = v_resto &gt; 1 ? 11 - v_resto : 0;
      \n\t      
      \n\t  return v_digit;
      \n\t}'

      m 'p', m.trust "<img src='#{conf.imgPath}img/creativeCommons.png'> Este código está bajo la licencia Creative Commons Attribution 3.0 License."
      m 'p', m.trust 'Envianos su traducción del algoritmo y lo publicamos con gusto aquí. Hemos ofrecido en varias occasiones desde 
      el año 2008 a hacienda que añade nuestros traducciones a su documentación, pero hasta ahora no lo hicieron.'
    ]
