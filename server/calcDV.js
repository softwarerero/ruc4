function calcDv(ruc) {
  var i, it, k, numero_aux, resto, total;
  k = 2;
  total = 0;
  ruc = parseInt(ruc).toString().split('');
  for (i = ruc.length - 1; i >= 0; i += -1) {
    it = ruc[i];
    numero_aux = it.charCodeAt(0) - 48;
    k = k > 11 ? 2 : k;
    total += numero_aux * k++;
  }
  resto = total % 11;
  if (resto > 1) {
    return 11 - resto;
  } else {
    return 0;
  }
};
