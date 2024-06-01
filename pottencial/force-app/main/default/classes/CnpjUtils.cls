/**
 *  @author
 *  @company
 *  @description  Classe responsável por metodos de utilidade contra CNPJ validação mascaras e etc
 *  @lastOnDemand 
**/
public class CnpjUtils {
    private String numeroCNPJ;

    private static final List<String> CNPJ_BLACKLIST = new List<String> {
        '00000000000000', '11111111111111', '22222222222222', '33333333333333', '44444444444444', 
        '55555555555555', '66666666666666', '77777777777777', '88888888888888', '99999999999999'
    };

    /**
    * Constroi um objeto com uma String representando o número do CNPJ.
    * Se a String não representar um CNPJ válido, o objeto não será criado e uma CPFInvalidoException será lançada.
    * @param numeroCNPJ A String contendo o CNPJ.
    * @throws CPFInvalidoException se o CNPJ for inválido.
    */
    public CnpjUtils(String numeroCNPJ){
        this.setNumeroCNPJ(numeroCNPJ);
    }

    /**
     * Tenta definir o número do CNPJ.
    * Se o CNPJ estiver correto com relação ao formato e dígito verificador, será definido no objeto, caso contrário,
    * uma CPFInvalidoException será lançada. Os formatos permitidos são: XX.XXX.XXX/XXXX-XX ou XXXXXXXXXXXXXX.
    * @param numeroCNPJ A String contendo o CNPJ.
    * @throws CPFInvalidoException se o CNPJ for inválido.
    */
    public void setNumeroCNPJ(String numeroCNPJ){
        validarFormato(numeroCNPJ);
        validarDigitoVerificador(numeroCNPJ);
        this.numeroCNPJ = removerFormatacao(numeroCNPJ);
    }

    /**
     * Verifica se o formato do CNPJ está correto (XX.XXX.XXX/XXXX-XX ou XXXXXXXXXXXXXX).
    * @param numeroCNPJ A String contendo o CNPJ.
    * @throws CPFInvalidoException se o formato do CNPJ for inválido.
    */
    private static void validarFormato(String numeroCNPJ){
        Matcher CNPJMatcher = null;
        String expressaoRegular = '(^(\\d{2}[.]\\d{3}[.]\\d{3}[\\/]\\d{4}[-]\\d{2})|(\\d{14})$)';
        Boolean CNPJValido = false;
        
        if ( String.isNotBlank( numeroCNPJ ) ) {
            CNPJMatcher = Pattern.compile( expressaoRegular ).matcher( numeroCNPJ );
            CNPJValido = CNPJMatcher.matches();
        }
        if( ! CNPJValido ) {
            throw new CPFInvalidoException('O CNPJ deve ser numérico obedecendo os seguintes formatos: XX.XXX.XXX/XXXX-XX ou XXXXXXXXXXXXXX.');
        }
    }

    /**
     * Verifica se o dígito verificador do CNPJ (que é composto por dois dígitos) está correto.
    * @param numeroCNPJ A String contendo o CNPJ.
    * @throws CPFInvalidoException se o dígito verificador do CNPJ estiver incorreto, ou se o CNPJ
    * for compostos por números repetidos (de 00000000000 a 99999999999).
    */
    private static void validarDigitoVerificador(String numeroCNPJ){
        Integer primeiroDigitoVerificador = null;
        Integer segundoDigitoVerificador = null;
        Integer digitoVerificadorCalculado = null;
        String CNPJAux = removerFormatacao(numeroCNPJ);
        
        //antes de validar os dígitos verificadores, verifica se o CNPJ esta presente na blacklist (todos passariam na validação dos dígitos verificadores mas são inválidos)
        if( CNPJ_BLACKLIST.contains( CNPJAux ) ) {
            throw new CPFInvalidoException('CNPJ inválido.');
        }

        primeiroDigitoVerificador = Integer.valueOf(CNPJAux.substring(12, 13));
        digitoVerificadorCalculado = calcularPrimeiroDigitoVerificador(CNPJAux);

        if(primeiroDigitoVerificador != digitoVerificadorCalculado){
            throw new CPFInvalidoException('O primeiro dígito verificador do CNPJ está incorreto.');
        }

        segundoDigitoVerificador = Integer.valueOf(CNPJAux.substring(13));
        digitoVerificadorCalculado = calcularSegundoDigitoVerificador(CNPJAux);

        if(segundoDigitoVerificador  != digitoVerificadorCalculado){
            throw new CPFInvalidoException('O segundo dígito verificador do CNPJ está incorreto.');
        }
    }

    /**
     * Calcula o primeiro dígito verificador do CNPJ.
    * @param numeroCNPJ O número do CNPJ.
    * @return Um inteiro que representa o primeiro dígito verificador do CNPJ.
    */
    private static Integer calcularPrimeiroDigitoVerificador(String numeroCNPJ){
        Integer sm=0, peso=2, dig13 = 0;
        List<String> cnpjString = numeroCNPJ.split('');
                    
        for ( Integer i = 11; i > =0; i-- ) {
            Integer num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            
            peso += 1;
            
            if (peso == 10) {
                peso = 2;
            }
            
        }

        Integer r = math.mod(sm, 11);
        if ( r > 1 ) {
            dig13 = Integer.valueOf(11-r);
        }

        return dig13;
    }

    /**
     * Calcula o segundo dígito verificador do CNPJ.
    * @param numeroCNPJ O número do CNPJ.
    * @return Um inteiro que representa o segundo dígito verificador do CNPJ.
    */
    private static Integer calcularSegundoDigitoVerificador(String numeroCNPJ){
        Integer sm=0, peso=2, dig14 = 0;
        List<String> cnpjString = numeroCNPJ.split('');
        
        for ( Integer i = 12; i >= 0; i-- ) {
            Integer num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso += 1;
            
            if (peso == 10) {
                peso = 2;
            }
        }

        Integer r = math.mod(sm, 11);
        if ( r > 1 ) {
            dig14 = Integer.valueOf(11-r);
        }

        return dig14;
    }

    /**
     * Verifica se uma determinada String representa um CNPJ válido.
    * @param numeroCNPJ A String contendo o CNPJ.
    * @return Um objeto CNPJUtils.ResultadoValidacao contendo o resultado da validação. Se o CNPJ for válido, o atributo
    * isCNPJValido será true, caso contrário, será false e o atributo mensagem estará preenchido com o erro da validação.
    */
    public static CNPJUtils.ResultadoValidacao validar(String numeroCNPJ){
        CNPJUtils.ResultadoValidacao validacao = new CNPJUtils.ResultadoValidacao();
        try{
            validarFormato(numeroCNPJ);
            validarDigitoVerificador(numeroCNPJ);
            validacao.isCNPJValido = true;
            validacao.mensagem = null;
        }
        catch(CPFInvalidoException ex){
            validacao.isCNPJValido = false;
            validacao.mensagem = ex.getMessage();
        }
        return validacao;
    }

    /**
    * Formata o CNPJ.
    * @param numeroCNPJ O número do CNPJ a ser formatado.
    * @return O CNPJ com formatação.
    */
    public static String formatar(String numeroCNPJ){
        String CNPJFormatado = numeroCNPJ.substring(0, 2) + '.' + numeroCNPJ.substring(2, 5) + '.' + numeroCNPJ.substring(5, 8) + '/' + numeroCNPJ.substring(8, 12) + '-' + numeroCNPJ.substring(12);
        return CNPJFormatado;
    }

    /**
    * Remove a formatação do CNPJ.
    * @param numeroCNPJ O número do CNPJ.
    * @return O CNPJ sem formatação.
    */
    public static String removerFormatacao(String numeroCNPJ){
        String STRICT_STRIP_REGEX = '[-\\/.]';
        return numeroCNPJ.replaceAll(STRICT_STRIP_REGEX, '');
    }

    /**
     * Retorna o número do CNPJ que foi definido no objeto.
    * @return A String contendo o CNPJ sem formatação.
    */
    public String getNumeroCNPJ(){
        return this.numeroCNPJ;
    }

    /**
     * Retorna o número do CNPJ que foi definido no objeto, porém, com a devida formatação.
    * @return A String contendo o CNPJ formatado.
    */
    public String getNumeroCNPJFormatado(){
        String CNPJFormatado = formatar(this.numeroCNPJ);
        return CNPJFormatado;
    }

    public class ResultadoValidacao {
        public Boolean isCNPJValido {get; set;}
        public String mensagem {get; set;}
    }
}