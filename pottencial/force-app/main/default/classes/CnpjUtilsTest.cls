/**
 *  @author Nícolas Bruno
 *  @company XCL Company - 2021
 *  @description Classe responsável por validar a classes de teste de CnpjUtils
 *  @lastOnDemand 
**/
@isTest
public class CnpjUtilsTest {

    /**
    * Testa o método setNumeroCNPJ.
    */
    @isTest private static void setNumeroCNPJUtils(){

        CnpjUtils CNPJ = null;
        Boolean CNPJInvalido = false;

        //Teste 1: CNPJ nulo
        try{
            CNPJ = new CnpjUtils(null);
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 1');

        //Teste 2: CNPJ em branco
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('            ');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 2');

        //Teste 3: CNPJ preenchido com a formatação correta mas com letras
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('AA.BBB.CCC/DDDD-EE');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 3');

        //Teste 4: CNPJ preenchido sem formatação (11 dígitos) mas com letras
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('AABBBCCCDDDDEE');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 4');

        //Teste 5: CNPJ preenchido com a formatação mas faltando o último dígito
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66.138.133/0001-3');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 5');

        //Teste 6: CNPJ preenchido sem formatação mas faltando o último dígito
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('6613813300013');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 6');

        //Teste 7: CNPJ preenchido com formatação e dígitos verificadores corretos, mas é inválido (de 00.000.000/0000-00 a 99.999.999/9999-99 são todos inválidos)
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('99.999.999/9999-99');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 7');

        //Teste 8: CNPJ preenchido sem formatação e dígitos verificadores corretos, mas é inválido (de 00000000000000 a 99999999999999 são todos inválidos)
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('99999999999999');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 8');

        //Teste 9: CNPJ preenchido com formatação correta, porém, com o primeiro dígito verificador inválido
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66.138.133/0001-47');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 9');

        //Teste 10: CNPJ preenchido sem formatação(14 dígitos), porém, com o primeiro dígito verificador inválido
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66138133000147');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 10');

        //Teste 11: CNPJ preenchido com formatação correta, porém, com o segundo dígito verificador inválido
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66.138.133/0001-38');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 11');

        //Teste 12: CNPJ preenchido sem formatação(14 dígitos), porém, com o segundo dígito verificador inválido
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66138133000138');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, true, 'CNPJ invalido teste 12');

        //Teste 13: CNPJ válido com relação ao formato (com e sem formatação) e aos dígitos verificadores
        CNPJInvalido = false;
        try{
            CNPJ = new CnpjUtils('66.138.133/0001-37');
            CNPJ = new CnpjUtils('66138133000137');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        //certifica de que dessa vez o objeto CNPJ foi instanciado (não passou na exception)
        System.assertEquals(CNPJInvalido, false, 'CNPJ invalido teste 13');

        //Teste 14: altera o número do CNPJ (instanciado no Teste 14) para outro CNPJ válido (com e sem formatação)
        CNPJInvalido = false;
        try{
            CNPJ.setNumeroCNPJ('53.362.542/0001-70');
            CNPJ.setNumeroCNPJ('53362542000170');
        }
        catch(CPFInvalidoException ex){
            CNPJInvalido = true;
        }
        System.assertEquals(CNPJInvalido, false, 'CNPJ invalido teste 14');
    }

    /**
    * Testa o método validar.
    */
    @isTest private static void validar(){
        CnpjUtils.ResultadoValidacao validacao = null;
        //Teste 1: CNPJ inválido, primeiro dígito verificador incorreto
        validacao = CnpjUtils.validar('53.362.542/0001-80');
        System.assertEquals(validacao.isCNPJValido, false, 'Resultado diferente do esperado');
        System.assert(String.isNotEmpty(validacao.mensagem), 'Resultado diferente do esperado');
        //Teste 2: CNPJ válido
        validacao = CnpjUtils.validar('53.362.542/0001-70');
        System.assertEquals(validacao.isCNPJValido, true, 'Resultado diferente do esperado');
        System.assert(validacao.mensagem == null, 'Resultado diferente do esperado');
    }

    /**
    * Testa o método getNumeroCNPJ.
    */
    @isTest private static void getNumeroCNPJUtils(){
        CnpjUtils CNPJ = new CnpjUtils('53.362.542/0001-70');
        //certifica de que o CNPJ retornado não possui formatação (esse é o propósito do método, retornar sem formatação ainda que seja instanciado formatado)
        System.assertEquals(CNPJ.getNumeroCNPJ(), '53362542000170', 'Resultado diferente do esperado');
    }

    /**
    * Testa o método getNumeroCNPJFormatado.
    */
    @isTest private static void getNumeroCNPJFormatado(){
        CnpjUtils CNPJ = new CnpjUtils('53362542000170');
        //certifica de que o CNPJ retornado possui formatação (esse é o propósito do método, retornar com formatação ainda que seja instanciado sem formato)
        System.assertEquals(CNPJ.getNumeroCNPJFormatado(), '53.362.542/0001-70', 'Resultado diferente do esperado');
    }
}