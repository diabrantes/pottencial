/**
 *  @author
 *  @company 
 *  @description  Classe responsável por metodos de utilidade contra cpf validação mascaras e etc
 *  @lastOnDemand 
**/
public with sharing class CpfUtils {

    private String numeroCPF;

    /**
    * Constroi um objeto com uma String representando o número do CPF.
    * Se a String não representar um CPF válido, o objeto não será criado e uma CPFInvalidoException será lançada.
    * @param numeroCPF A String contendo o CPF.
    * @throws CPFInvalidoException se o CPF for inválido.
    */
    public CpfUtils(String numeroCPF){
        this.setNumeroCPF(numeroCPF);
    }

    /**
     * Tenta definir o número do CPF.
    * Se o CPF estiver correto com relação ao formato e dígito verificador, será definido no objeto, caso contrário,
    * uma CPFInvalidoException será lançada. Os formatos permitidos são: XXX.XXX.XXX-XX ou XXXXXXXXXXX.
    * @param numeroCPF A String contendo o CPF.
    * @throws CPFInvalidoException se o CPF for inválido.
    */
    public void setNumeroCPF(String numeroCPF){
        validarFormato(numeroCPF);
        validarDigitoVerificador(numeroCPF);
        this.numeroCPF = removerFormatacao(numeroCPF);
    }

    /**
     * Verifica se o formato do CPF está correto (XXX.XXX.XXX-XX ou XXXXXXXXXXX).
    * @param numeroCPF A String contendo o CPF.
    * @throws CPFInvalidoException se o formato do CPF for inválido.
    */
    private static void validarFormato(String numeroCPF){
        Matcher cpfMatcher = null;
        String expressaoRegular = '(^(\\d{3}[.]\\d{3}[.]\\d{3}[-]\\d{2})|(\\d{11})$)';
        Boolean cpfValido = false;
        if(String.isNotBlank(numeroCPF)){
            cpfMatcher = Pattern.compile(expressaoRegular).matcher(numeroCPF);
            cpfValido = cpfMatcher.matches();
        }
        if(!cpfValido){
            throw new CPFInvalidoException('O CPF deve ser numérico obedecendo os seguintes formatos: XXX.XXX.XXX-XX ou XXXXXXXXXXX.');
        }
    }

    /**
     * Verifica se o dígito verificador do CPF (que é composto por dois dígitos) está correto.
    * @param numeroCPF A String contendo o CPF.
    * @throws CPFInvalidoException se o dígito verificador do CPF estiver incorreto, ou se o CPF
    * for compostos por números repetidos (de 00000000000 a 99999999999).
    */
    private static void validarDigitoVerificador(String numeroCPF){
        Integer primeiroDigitoVerificador = null;
        Integer segundoDigitoVerificador = null;
        Integer digitoVerificadorCalculado = null;
        String cpfAux = removerFormatacao(numeroCPF);
        //antes de validar os dígitos verificadores, verifica se o cpf é algum dos abaixo (todos passariam na validação dos dígitos verificadores mas são inválidos)
        if((cpfAux.equals('00000000000')) || (cpfAux.equals('11111111111')) ||
            (cpfAux.equals('22222222222')) || (cpfAux.equals('33333333333')) ||
            (cpfAux.equals('44444444444')) || (cpfAux.equals('55555555555')) ||
            (cpfAux.equals('66666666666')) || (cpfAux.equals('77777777777')) ||
            (cpfAux.equals('88888888888')) || (cpfAux.equals('99999999999'))){
        throw new CPFInvalidoException('CPF inválido.');

        }
        primeiroDigitoVerificador = Integer.valueOf(cpfAux.substring(9, 10));
        digitoVerificadorCalculado = calcularPrimeiroDigitoVerificador(cpfAux);

        if(primeiroDigitoVerificador != digitoVerificadorCalculado){
            throw new CPFInvalidoException('O primeiro dígito verificador do CPF está incorreto.');
        }

        segundoDigitoVerificador = Integer.valueOf(cpfAux.substring(10));
        digitoVerificadorCalculado = calcularSegundoDigitoVerificador(cpfAux);

        if(segundoDigitoVerificador  != digitoVerificadorCalculado){
            throw new CPFInvalidoException('O segundo dígito verificador do CPF está incorreto.');
        }
    }

    /**
     * Calcula o primeiro dígito verificador do CPF.
    * @param numeroCPF O número do CPF.
    * @return Um inteiro que representa o primeiro dígito verificador do CPF.
    */
    private static Integer calcularPrimeiroDigitoVerificador(String numeroCPF){
        Integer restoDivisao = null;
        Integer primeiroDigitoVerificador = null;
        Integer[] arrVerificacao = new Integer[]{10, 9, 8, 7, 6, 5, 4, 3, 2};
        Integer soma = 0;
        for (Integer i = 0; i < arrVerificacao.size(); i++){
            //multiplica o valor do número do array de verificação pelo correspondente da variável cpf
            soma += arrVerificacao[i] * (Integer.valueOf(numeroCPF.substring(i, i+1)));
        }
        //obtém o resto da divisão do valor acumulado dividido por 11
        restoDivisao = Math.mod(soma, 11);
        //verifica o resto da divisão para determinar o primeiro dígito verificador
        primeiroDigitoVerificador = (restoDivisao < 2) ? 0 : (11 - restoDivisao);
        return primeiroDigitoVerificador;
    }

    /**
     * Calcula o segundo dígito verificador do CPF.
    * @param numeroCPF O número do CPF.
    * @return Um inteiro que representa o segundo dígito verificador do CPF.
    */
    private static Integer calcularSegundoDigitoVerificador(String numeroCPF){
        Integer restoDivisao = null;
        Integer segundoDigitoVerificador = null;
        Integer[] arrVerificacao = new Integer[]{11, 10, 9, 8, 7, 6, 5, 4, 3, 2};
        Integer soma = 0;
        for (Integer i = 0; i < arrVerificacao.size(); i++){
            //multiplica o valor do número do array de verificação pelo correspondente da variável cpf
            soma += arrVerificacao[i] * (Integer.valueOf(numeroCPF.substring(i, i+1)));
        }
        //obtém o resto da divisão do valor acumulado dividido por 11
        restoDivisao = Math.mod(soma, 11);
        //verifica o resto da divisão para determinar o segundo dígito verificador
        segundoDigitoVerificador = (restoDivisao < 2) ? 0 : (11 - restoDivisao);
        return segundoDigitoVerificador;
    }

    /**
     * Verifica se uma determinada String representa um CPF válido.
    * @param numeroCPF A String contendo o CPF.
    * @return Um objeto CpfUtils.ResultadoValidacao contendo o resultado da validação. Se o CPF for válido, o atributo
    * isCPFValido será true, caso contrário, será false e o atributo mensagem estará preenchido com o erro da validação.
    */
    public static CpfUtils.ResultadoValidacao validar(String numeroCPF){
        CpfUtils.ResultadoValidacao validacao = new CpfUtils.ResultadoValidacao();
        try{
            validarFormato(numeroCPF);
            validarDigitoVerificador(numeroCPF);
            validacao.isCPFValido = true;
            validacao.mensagem = null;
        }
        catch(CPFInvalidoException ex){
            validacao.isCPFValido = false;
            validacao.mensagem = ex.getMessage();
        }
        return validacao;
    }

    /**
    * Formata o CPF.
    * @param numeroCPF O número do CPF a ser formatado.
    * @return O CPF com formatação.
    */
    public static String formatar(String numeroCPF){
        String cpfFormatado = numeroCPF.substring(0, 3) + '.' + numeroCPF.substring(3, 6) + '.' + numeroCPF.substring(6, 9) + '-' + numeroCPF.substring(9);
        return cpfFormatado;
    }

    /**
    * Remove a formatação do CPF.
    * @param numeroCPF O número do CPF.
    * @return O CPF sem formatação.
    */
    public static String removerFormatacao(String numeroCPF){
        String cpfSemFormatacao = numeroCPF.replaceAll('[^0-9]', '').trim();
        return cpfSemFormatacao;
    }

    /**
     * Retorna o número do CPF que foi definido no objeto.
    * @return A String contendo o CPF sem formatação.
    */
    public String getNumeroCPF(){
        return this.numeroCPF;
    }

    /**
     * Retorna o número do CPF que foi definido no objeto, porém, com a devida formatação.
    * @return A String contendo o CPF formatado.
    */
    public String getNumeroCPFFormatado(){
        String cpfFormatado = formatar(this.numeroCPF);
        return cpfFormatado;
    }

    public static Boolean isCPF(String numeroCPF) {
        Matcher cpfMatcher = null;
        String expressaoRegular = '(^(\\d{3}[.]\\d{3}[.]\\d{3}[-]\\d{2})|(\\d{11})$)';
        Boolean cpfValido = false;
        if (String.isNotBlank(numeroCPF)) {
            cpfMatcher = Pattern.compile(expressaoRegular).matcher(numeroCPF);
            cpfValido = cpfMatcher.matches();
        }
        return cpfValido;
    }

    public class ResultadoValidacao{
        public Boolean isCPFValido {get; set;}
        public String mensagem {get; set;}
    }
}