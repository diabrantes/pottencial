/**
 *  @author 
 *  @company
 *  @description Classe responsável por validar a classes de teste de CpfUitl
 *  @lastOnDemand 
**/
@isTest
public with sharing class CpfUtilsTest {

    /**
    * Testa o método setNumeroCPF.
    */
    @isTest private static void setNumeroCpfUtils(){

        CpfUtils cpf = null;
        Boolean cpfInvalido = false;

        //Teste 1: CPF nulo
        try{
            cpf = new CpfUtils(null);
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 1');

        //Teste 2: CPF em branco
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('         ');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 2');

        //Teste 3: CPF preenchido com a formatação correta mas com letras
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('AAA.BBB.CCC-DD');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 3');

        //Teste 4: CPF preenchido sem formatação (11 dígitos) mas com letras
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('AAABBBCCCDD');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 4');

        //Teste 5: CPF preenchido com a formatação mas faltando o último dígito
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('452.100.689-2');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 5');

        //Teste 6: CPF preenchido sem formatação mas faltando o último dígito
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('4521006892');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 6');

        //Teste 7: CPF preenchido com formatação e dígitos verificadores corretos, mas é inválido (de 000.000.000-00 a 999.999.999-99 são todos inválidos)
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('999.999.999-99');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 7');

        //Teste 8: CPF preenchido sem formatação e dígitos verificadores corretos, mas é inválido (de 00000000000 a 99999999999 são todos inválidos)
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('99999999999');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 8');

        //Teste 9: CPF preenchido com formatação correta, porém, com o primeiro dígito verificador inválido
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('452.100.689-17');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 9');

        //Teste 10: CPF preenchido sem formatação(11 dígitos), porém, com o primeiro dígito verificador inválido
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('45210068917');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 10');

        //Teste 11: CPF preenchido com formatação correta, porém, com o segundo dígito verificador inválido
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('452.100.689-26');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 11');

        //Teste 12: CPF preenchido sem formatação(11 dígitos), porém, com o segundo dígito verificador inválido
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('45210068926');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, true, 'CPF invalido teste 12');

        //Teste 13: CPF válido com relação ao formato (com e sem formatação) e aos dígitos verificadores
        cpfInvalido = false;
        try{
            cpf = new CpfUtils('452.100.689-27');
            cpf = new CpfUtils('45210068927');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        //certifica de que dessa vez o objeto cpf foi instanciado (não passou na exception)
        system.assertEquals(cpfInvalido, false, 'CPF invalido teste 13');

        //Teste 14: altera o número do CPF (instanciado no Teste 11) para outro CPF válido (com e sem formatação)
        cpfInvalido = false;
        try{
            cpf.setNumeroCPF('663.436.785-06');
            cpf.setNumeroCPF('66343678506');
        }
        catch(CPFInvalidoException ex){
            cpfInvalido = true;
        }
        system.assertEquals(cpfInvalido, false, 'CPF invalido teste 14');
    }

    /**
    * Testa o método validar.
    */
    @isTest private static void validar(){
        CpfUtils.ResultadoValidacao validacao = null;
        //Teste 1: CPF inválido, primeiro dígito verificador incorreto
        validacao = CpfUtils.validar('452.100.689-17');
        system.assertEquals(validacao.isCPFValido, false, 'Resultado diferente do esperado');
        system.assert(String.isNotEmpty(validacao.mensagem), 'Resultado diferente do esperado');
        //Teste 2: CPF válido
        validacao = CpfUtils.validar('452.100.689-27');
        system.assertEquals(validacao.isCPFValido, true, 'Resultado diferente do esperado');
        system.assert(validacao.mensagem == null, 'Resultado diferente do esperado');
    }

    /**
    * Testa o método getNumeroCPF.
    */
    @isTest private static void getNumeroCpfUtils(){
        CpfUtils cpf = new CpfUtils('452.100.689-27');
        //certifica de que o CPF retornado não possui formatação (esse é o propósito do método, retornar sem formatação ainda que seja instanciado formatado)
        system.assertEquals(cpf.getNumeroCPF(), '45210068927', 'Resultado diferente do esperado');
    }

    /**
    * Testa o método getNumeroCPFFormatado.
    */
    @isTest private static void getNumeroCPFFormatado(){
        CpfUtils cpf = new CpfUtils('45210068927');
        //certifica de que o CPF retornado possui formatação (esse é o propósito do método, retornar com formatação ainda que seja instanciado sem formato)
        system.assertEquals(cpf.getNumeroCPFFormatado(), '452.100.689-27', 'Resultado diferente do esperado');
    }
}