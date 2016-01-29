calcDv = (ruc) ->
  k = 2; total = 0
  ruc = parseInt(ruc).toString().split ''
  for it in ruc by -1
    numero_aux = it.charCodeAt(0) - 48
    k = if k > 11 then 2 else k
    total += numero_aux * k++
  resto = total % 11
  if resto > 1 then 11 - resto else 0
