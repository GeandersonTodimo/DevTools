/*/{Protheus.doc} FI03I01
@description Include com definição de Tabelas e Campos para rotina de SQL Exportação

@author  Helitom Silva
@since   29/02/2016
@version 1.0

/*/

/* Cadastro de SQL Exportação */
#DEFINE TBZ11 GetTable('TBZ11')

#DEFINE Z11FILIAL GetField('TBZ11', 'FILIAL')
#DEFINE Z11CODIGO GetField('TBZ11', 'CODIGO')
#DEFINE Z11GRUPO GetField('TBZ11', 'GRUPO')
#DEFINE Z11DESC GetField('TBZ11', 'DESC')
#DEFINE Z11SQL GetField('TBZ11', 'SQL')
#DEFINE Z11DIR GetField('TBZ11', 'DIR')
#DEFINE Z11FILE GetField('TBZ11', 'FILE')
#DEFINE Z11TPFILE GetField('TBZ11', 'TPFILE')
#DEFINE Z11DELCSV GetField('TBZ11', 'DELCSV')
#DEFINE Z11TFIELD GetField('TBZ11', 'TFIELD')
#DEFINE Z11HREXP GetField('TBZ11', 'HREXP')
#DEFINE Z11DTEXP GetField('TBZ11', 'DTEXP')
#DEFINE Z11MSBLQL GetField('TBZ11', 'MSBLQL')


/*/{Protheus.doc} GetTable
@description Obtem Alias da Tabela Real usada

@author  Helitom Silva
@since   29/02/2016
@version 1.0

@param p_cTabCus, Caracter, Nome da Tabela da Customização

@return cRet, Caracter, Alias da Tabela

/*/
Static Function GetTable(p_cTabCus)
	
	Local cRet	  := ''
	Local oTabCus := IdaTBC():New()
	
	cRet := oTabCus:GetTbCAlias(p_cTabCus)
	
Return cRet


/*/{Protheus.doc} GetField
@description Obtem Nome do Campo da Tabela Real usada

@author  Helitom Silva
@since   29/02/2016
@version 1.0

@param p_cTabCus, Caracter, Nome da Tabela da Customização
@param p_cField, Caracter, Nome do Campo da Tabela da Customização

@return cRet, Caracter, Alias da Tabela

/*/
Static Function GetField(p_cAlias, p_cField)
	
	Local cRet	  := ''
	Local oTabCus := IdaTBC():New()
	
	cRet := oTabCus:GetTbCField(p_cAlias, p_cField)
	
Return cRet


/*/{Protheus.doc} GetValue
@description Obtem Valor do Campo de um Alias aberto

@author  Helitom Silva
@since   01/09/2016
@version 1.0

@param p_cTabCus, Caracter, Nome do Alias(Tabela)
@param p_cField, Caracter, Nome do Campo do Alias(Tabela)

@return uRet, Indefinido, Valor do Campo

/*/
Static Function GetValue(p_cAlias, p_cField)
	
	Local uRet
	
	Default p_cAlias := ''
	Default p_cField := ''

	uRet := &(p_cAlias + '->' + p_cField)
	
Return uRet