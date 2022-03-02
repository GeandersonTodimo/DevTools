#INCLUDE 'PROTHEUS.CH'


/*/{Protheus.doc} UPDSXA
Abstração do dicionario SXA.
@type class
@author		helitom.silva
@since 		05/10/2012
@version  	1.0
@method		{create} 	cria um novo objeto
@method 	{add} 	 	adiciona uma pasta a tabela
@method 	{s}		 	seta os atributos da pasta
@method 	{remove} 	remove uma pasta se existir,ou todas do alias
@method		{confirm}	comita as pastas adicionadas
@method		{setlog}	seta o objeto responsavel pelo log
/*/
CLASS UPDSXA

	DATA STRUCT
	DATA MODEL
	DATA MODELS //ACUMULA OS MODELOS ATÉ O CONFIRMA
	DATA OLOG

	METHOD CREATE() CONSTRUCTOR
	METHOD ADDPASTA()
	METHOD ADDCAMPOS()
	METHOD S()
	METHOD REMOVE()
	METHOD CONFIRM()
	METHOD SETLOG()

ENDCLASS


/*/{Protheus.doc} UPDSXA::CREATE
	Breve descricao de como se comporta cada etapa para	Criacao de uma consulta Padrao.
	Exemplo: Consulta Posto de Coleta
	{XA_ALIAS   = Tabela a qual as pastas serão criadas
	XA_ORDEM   = Sequencia da Pasta /Codigo da pasta
	XA_DESCRIC = Descricao da Pasta em Portugues
	XA_DESCSPA = Descricao da Pasta em Espanhol
	XA_DESCENG = Descricao da Pasta em Ingles
	XA_PROPRI  = Valor Default 'S'
	XA_AGRUP  	= Pasta de Agrupamento
	XA_TIPO  	= ( 2 ) Agrupamento E ( 0 ) Pasta}
	@type method
/*/
METHOD CREATE() CLASS UPDSXA

	::STRUCT := { 'ALIAS' , 'ORDEM' , 'DESCRIC'  , 'DESCSPA'  ,'DESCENG'  ,'PROPRI', 'AGRUP', 'TIPO' }
	::MODELS := {}

	IF TYPE("OLOG") != "U"
		::OLOG 	 := OLOG
	ELSE
		::OLOG 	 := UPDLOG():CREATE()
	ENDIF

RETURN SELF


/*/{Protheus.doc} UPDSXA::ADDPASTA
Adiciona para inclusão ou atualização na base
@type method
@author	helitom.silva
@since 05/10/2021
@history 02/03/2022,geanderson.silva, Adicionando novas propriedades.
/*/
METHOD ADDPASTA(CALIAS, CORDEM, CDESCRIC, CDESCSPA, CDESCENG, CPROPRI, CAGRUP, CTIPO ) CLASS UPDSXA
	/*
	 Exemplo de como sera feito a inclusão dos campos.

	 XA_ALIAS   := CALIAS       //Tabela a qual as pastas serão criadas
	 XA_ORDEM   := CORDEM       //Sequencia da Pasta/Codigo da pasta
	 XA_DESCRIC := CDESCRIC     //Descricao da Pasta em Portugues
	 XA_DESCSPA := CDESCSPA     //Descricao da Pasta em Espanhol
	 XA_DESCENG := CDESCENG     //Descricao da Pasta em Ingles
	 XA_PROPRI  := CPROPRI      //Valor Default 'S'
	 XA_AGRUP  := CAGRUP       	//Pasta de Agrupamento
	 XA_TIPO  := CPROPRI       	//( 2 ) Agrupamento E ( 0 ) Pasta
	*/
	DEFAULT CPROPRI := 'S'

	::MODEL := {  '' ,;//XA_ALIAS
				  '' ,;//XA_ORDEM
			  	  '' ,;//XA_DESCRIC
				  '' ,;//XA_DESCSPA
				  '' ,;//XA_DESCENG
				  '' ,; //XA_PROPRI
				  '' ,; //XA_AGRUP
				  '' } //XA_TIPO

	AADD(::MODELS, ::MODEL)	 //REGISTRA O MODELO NA LISTA DE MODELOS

	SELF:S('ALIAS'		, CALIAS)
	SELF:S('ORDEM'		, CORDEM)
	SELF:S('DESCRIC' 	, CDESCRIC)
	SELF:S('DESCSPA' 	, CDESCSPA)
	SELF:S('DESCENG'	, CDESCENG)
	SELF:S('PROPRI'		, CPROPRI)
	SELF:S('AGRUP'		, CAGRUP)
	SELF:S('TIPO'		, CTIPO)

RETURN SELF


/*
SETA O VALOR DO ATRIBUTO
*/
METHOD S(ATTR, VALOR) CLASS UPDSXA
	LOCAL I := ASCAN(::STRUCT, ATTR)

	IF I = 0
		::OLOG:LOG("ATENCAO: Não foi possível configurar o atributo: "+ATTR+"!")
	ELSE
		::MODEL[I] := VALOR
	ENDIF

RETURN SELF

/*
CONFIRMA A GRAVAÇÃO DO REGISTRO
*/
METHOD CONFIRM() CLASS UPDSXA

	LOCAL I

	::OLOG:LOG("As seguintes Pastas foram adicionados ao dicionário SXA")

	DBSELECTAREA("SXA")
	DBSETORDER(1)

	FOR I := 1 TO LEN(::MODELS)

		::OLOG:LOG(" A Pasta : "+::MODELS[I][02]+" da Tabela: "+::MODELS[I][01]+"]")

		dbGoTop()
		IIf(dbSeek(::MODELS[I][01] + ::MODELS[I][02]),RLock(),dbAppend())
			 XA_ALIAS   := ::MODELS[I][01]
			 XA_ORDEM   := ::MODELS[I][02]
			 XA_DESCRIC := ::MODELS[I][03]
			 XA_DESCSPA := ::MODELS[I][04]
			 XA_DESCENG := ::MODELS[I][05]
			 XA_PROPRI  := ::MODELS[I][06]
			 XA_AGRUP  	:= ::MODELS[I][07]
			 XA_TIPO  	:= ::MODELS[I][08]
		DBUNLOCK()

	NEXT

	::OLOG:LINE()

	::MODELS := {}

RETURN SELF



METHOD REMOVE(CALIAS, CORDEM, LTODAS) CLASS UPDSXA

	DEFAULT LTODAS := .F.

	DBSELECTAREA("SXA")
	DBSETORDER(1)

   If LTODAS
		dbGoTop()
		If dbSeek(CALIAS)
			While .Not. Eof() .And. XA_ALIAS = CALIAS
				If RLock()
					dbDelete()
					dbUnLock()
				EndIf
				dbSkip()
			EndDo
		EndIf
	Else
		dbGoTop()
		If dbSeek(CALIAS + CORDEM)
			If RLock()
				dbDelete()
				dbUnLock()
			EndIf
		EndIf
	EndIf

RETURN SELF


/* Gera log da execução */
METHOD SETLOG(OLOG) CLASS UPDSXA

	::OLOG := OLOG

RETURN SELF


/*{ProtheusDoc} UPDSXA::ADDCAMPOS
Adiciona para inclusão ou atualização na base
@author	helitom.silva
@since 	05/10/2021
*/
METHOD ADDCAMPOS(CALIAS, CORDEM, ACAMPOS) CLASS UPDSXA
	/*
	 Exemplo de como sera feito a inclusão dos campos.

	 CALIAS       //Tabela a qual as pastas serão criadas
	 CORDEM        //Sequencia da Pasta
	 ACAMPOS       //Array Unidimencional com nomes dos campos a serem vinculados a pasta {'A1_COD','A1_DESCR'}
	*/

	LOCAL        I := 0
	DEFAULT ACAMPOS := {}

	If Len(ACAMPOS) > 0
		For I := 1 to Len(ACAMPOS)
			SX3 := UPDSX3():CREATE()
			SX3:CLONE(ACAMPOS[I], ACAMPOS[I])
			SX3:S('FOLDER', CORDEM)
			SX3:CONFIRM()
		Next
	EndIf

RETURN SELF