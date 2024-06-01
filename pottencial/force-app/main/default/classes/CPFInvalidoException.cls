public with sharing class CPFInvalidoException extends Exception {
    public CPFInvalidoException(Exception causa, String mensagem) {
        this.initCause(causa);
        this.setMessage(mensagem);
    }
}