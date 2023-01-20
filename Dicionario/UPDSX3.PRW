#include 'totvs.ch'
#include 'devtools.ch'

/*{ProtheusDoc} UPDSX3

	Abstração do dicionário SX3

	@author	fernando.alencar
	@data		11 de outubro de 2011
	@method	{create} 	cria um novo objeto
	@method	{add} 	 	adiciona um indice
	@method 	{s}		 	seta os atributos do indice
	@method 	{remove} 	remove um indice se existir
	@method 	{confirm}	comita os indices adicionados
	@method 	{setlog}	seta o objeto responsavel pelo log

*/
CLASS UPDSX3

	DATA _STRUCT
	DATA MODEL
	DATA MODELS 		//ACUMULA OS MODELOS ATÉ O CONFIRMA
	DATA OLOG
	DATA CONSTANTS

	METHOD CREATE() CONSTRUCTOR
	METHOD ADD()
	METHOD CLONE()
	METHOD S()
	METHOD REMOVE()
	METHOD CONFIRM()
	METHOD SETLOG()
	METHOD ADDFILIAL()
	METHOD SETFILIAL()
	METHOD SETCHAVE()
	METHOD SETOBR()
	METHOD SETOPCIONAL()
	METHOD SETNAOUSADO()
	METHOD GETLOGTXT()
	METHOD UPDTABLE()
	METHOD SETHELP()
	METHOD REMOVEALL()
	METHOD SETORDEM()
		
ENDCLASS

/*{ProtheusDoc} UPDSX3:CREATE

	Metodo construtor

	@param		olog, variável {Private} com o objeto do tipo UPDLOG
	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD CREATE() CLASS UPDSX3

	IF TYPE("OLOG") != "U"
		::OLOG 	 := OLOG
	ELSE
		::OLOG 	 := UPDLOG():CREATE()
	ENDIF

	::_STRUCT := { 'ARQUIVO' 	,;
		'ORDEM' 		,;
		'CAMPO'		,;
		'TIPO'		,;
		'TAMANHO'	,;
		"DECIMAL"	,;
		"TITULO"		,;
		"TITSPA"		,;
		"TITENG"   	,;
		'DESCRIC'	,;
		'DESCSPA'	,;
		'DESCENG'  	,;
		'PICTURE' 	,;
		'VALID'		,;
		'USADO'		,;
		'RELACAO'	,;
		'F3'			,;
		'NIVEL'		,;
		'RESERV'		,;
		'CHECK'		,;
		'TRIGGER'	,;
		'PROPRI'		,;
		'BROWSE'		,;
		'VISUAL'		,;
		'CONTEXT'	,;
		'OBRIGAT'	,;
		'VLDUSER'	,;
		'CBOX'		,;
		'CBOXSPA'	,;
		'CBOXENG'	,;
		'PICTVAR'	,;
		'WHEN'		,;
		'INIBRW'		,;
		'GRPSXG'		,;
		'FOLDER'		,;
		'PYME'		,;
		'CONDSQL'	,;
		'CHKSQL'		,;
		'IDXSRV'		,;
		'ORTOGRA'	,;
		'IDXFLD'		,;
		'TELA'		,;
		'AGRUP'		,;
		'HELP'		}

	::MODELS := {}

RETURN SELF

/*{ProtheusDoc} UPDSX3:CLONE
	@description clona um campo e adiciona um novo campo ao modelo.

	@history 16/05/2015, Geanderson Silva, Cria��o do campo arquivo para evitar criar campo na tabela errada.

	@param	cFieldOri,character, campo do dicionário que será usado para criar o campo cFieldDes
	@param	cFieldDes,character, nome do novo campo
	@param	cArquivo,character, nome da tabela da SX2
	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD CLONE(CFIELDORI, CFIELDDES, CARQUIVO) CLASS UPDSX3

	Default CFIELDORI := ""
	Default CFIELDDES := ""
	Default CARQUIVO  := ""

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	SX3->(DbGoTop())
	If SX3->(DbSeek(PadR(CFIELDORI, 10)))

		If Empty( CARQUIVO )
			CARQUIVO  := X3_ARQUIVO
		EndIf

		cHelp 	:=	GetHelp(CFIELDORI)

		::MODEL 	:= {CARQUIVO    ,;//ARQUIVO
						'' 		    ,;//ORDEM
						CFIELDDES	,;//CAMPO
						X3_TIPO	    ,;//TIPO
						X3_TAMANHO	,;//TAMANHO
						X3_DECIMAL	,;//DECIMAL
						X3_TITULO	,;//TITULO
						X3_TITSPA	,;//TITSPA
						X3_TITENG   ,;//TITENG
						X3_DESCRIC	,;//DESCRIC
						X3_DESCSPA	,;//DESCSPA
						X3_DESCENG  ,;//DESCENG
						X3_PICTURE  ,;//PICTURE
						X3_VALID	,;//VALID
						X3_USADO	,;//USADO
						X3_RELACAO	,;//RELACAO
						X3_F3		,;//F3
						X3_NIVEL	,;//NIVEL
						X3_RESERV	,;//RESERV
						X3_CHECK	,;//CHECK
						X3_TRIGGER	,;//TRIGGER
						X3_PROPRI	,;//PROPRI
						X3_BROWSE	,;//BROWSE
						X3_VISUAL	,;//VISUAL
						X3_CONTEXT	,;//CONTEXT
						X3_OBRIGAT	,;//OBRIGAT
						X3_VLDUSER	,;//VLDUSER
						X3_CBOX	    ,;//CBOX
						X3_CBOXSPA	,;//CBOXSPA
						X3_CBOXENG	,;//CBOXENG
						X3_PICTVAR	,;//PICTVAR
						X3_WHEN	    ,;//WHEN
						X3_INIBRW	,;//INIBRW
						X3_GRPSXG	,;//GRPSXG
						X3_FOLDER	,;//FOLDER
						X3_PYME	    ,;//PYME
						X3_CONDSQL	,;//CONDSQL
						X3_CHKSQL	,;//CHKSQL
						X3_IDXSRV	,;//IDXSRV
						X3_ORTOGRA	,;//ORTOGRA
						X3_IDXFLD	,;//IDXFLD
						X3_TELA	    ,;//TELA
						X3_AGRUP	,;//AGRUP
						cHelp		} //HELP

		AADD(::MODELS, ::MODEL)						  			  	//REGISTRA O MODELO NA LISTA DE MODELOS
	ELSE
		CONOUT("ATENCAO: Não pois possível criar o campo: "+CFIELDDES+", pois o campo: "+CFIELDORI+"não existe no dicionário SX3!")
		::OLOG:LOG("ATENCAO: Não pois possível criar o campo: "+CFIELDDES+", pois o campo: "+CFIELDORI+"não existe no dicionário SX3!")
	ENDIF

RETURN

/*{ProtheusDoc} UPDSX3:ADD

	Adiciona um novo campo ao modelo

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD ADD(CALIAS) CLASS UPDSX3

	::MODEL := { CALIAS ,;//ARQUIVO
				 ''   ,;//ORDEM
				 ''	  ,;//CAMPO
				 ''	  ,;//TIPO
				 0	  ,;//TAMANHO
				 0	  ,;//DECIMAL
				 ''	  ,;//TITULO
				 ''	  ,;//TITSPA
				 ''   ,;//TITENG
				 ''	  ,;//DESCRIC
				 ''	  ,;//DESCSPA
				 ''   ,;//DESCENG
				 '@!' ,;//PICTURE
				 ''	  ,;//VALID
				 ''	  ,;//USADO
				 ''	  ,;//RELACAO
				 ''	  ,;//F3
				 1	  ,;//NIVEL
				 ''	  ,;//RESERV
				 ''	  ,;//CHECK
				 'N'  ,;//TRIGGER
				 'U'  ,;//PROPRI
				 'S'  ,;//BROWSE
				 'A'  ,;//VISUAL
				 'R'  ,;//CONTEXT
				 ''	  ,;//OBRIGAT
				 ''	  ,;//VLDUSER
				 ''	  ,;//CBOX
				 ''	  ,;//CBOXSPA
				 ''	  ,;//CBOXENG
				 ''	  ,;//PICTVAR
				 ''	  ,;//WHEN
				 ''	  ,;//INIBRW
				 ''	  ,;//GRPSXG
				 ''	  ,;//FOLDER
				 'S'  ,;//PYME
				 ''	  ,;//CONDSQL
				 ''	  ,;//CHKSQL
				 'N'  ,;//IDXSRV
				 'N'  ,;//ORTOGRA
				 'N'  ,;//IDXFLD
				 ''	  ,;//TELA
				 ''	  ,;//AGRUP
				 ''	  } //hELP 


	AADD(::MODELS, ::MODEL)						  			  	//REGISTRA O MODELO NA LISTA DE MODELOS
	
RETURN

/*{ProtheusDoc} UPDSX3:S

	Seta o valor do atributo

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD S(ATTR, VALOR) CLASS UPDSX3
	
	LOCAL I := ASCAN(::_STRUCT, ATTR)

	IF I = 0
		::OLOG:LOG("ATENCAO: Não foi possível configurar o atributo: "+ATTR+"!")
	ELSE
		::MODEL[I] := VALOR
	ENDIF
	
RETURN

/*{ProtheusDoc} UPDSX3:CONFIRM

	Grava o campos adicionados via add na tabela SX3

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD CONFIRM() CLASS UPDSX3

	LOCAL AAREA  := GETAREA()
	LOCAL ATABE  := {}
	LOCAL I
	LOCAL J

	DBSELECTAREA('SX3')
	DBSETORDER(1)

	::OLOG:LOG("Os seguintes campos foram criados ou atualizados na SX3")

	//PARA CADA CAMPO
	FOR I := 1 TO LEN(::MODELS)

		::OLOG:LOG("CAMPO ["+::MODELS[I][3]+"]")

		CORDEM := ::REMOVE(::MODELS[I][1],::MODELS[I][3], .F.) //ALIAS, CAMPO

		dbAppend()
		X3_ARQUIVO 	:=  ::MODELS[I][1]
		X3_ORDEM   	:=  CORDEM
		X3_CAMPO   	:=  ::MODELS[I][3]
		X3_TIPO    	:=  ::MODELS[I][4]
		X3_TAMANHO 	:=  ::MODELS[I][5]
		X3_DECIMAL 	:=  ::MODELS[I][6]
		X3_TITULO  	:=  ::MODELS[I][7]
		X3_TITSPA  	:=  ::MODELS[I][8]
		X3_TITENG  	:=  ::MODELS[I][9]
		X3_DESCRIC 	:=  ::MODELS[I][10]
		X3_DESCSPA 	:=  ::MODELS[I][11]
		X3_DESCENG 	:=  ::MODELS[I][12]
		X3_PICTURE 	:=  ::MODELS[I][13]
		X3_VALID   	:=  ::MODELS[I][14]
		X3_USADO   	:=  ::MODELS[I][15]
		X3_RELACAO 	:=  ::MODELS[I][16]
		X3_F3 	    :=  ::MODELS[I][17]
		X3_NIVEL   	:=  ::MODELS[I][18]
		X3_RESERV  	:=  ::MODELS[I][19]
		X3_CHECK   	:=  ::MODELS[I][20]
		X3_TRIGGER 	:=  ::MODELS[I][21]
		X3_PROPRI  	:=  ::MODELS[I][22]
		X3_BROWSE  	:=  ::MODELS[I][23]
		X3_VISUAL  	:=  ::MODELS[I][24]
		X3_CONTEXT 	:=  ::MODELS[I][25]
		X3_OBRIGAT 	:=  ::MODELS[I][26]
		X3_VLDUSER 	:=  ::MODELS[I][27]
		X3_CBOX    	:=  ::MODELS[I][28]
		X3_CBOXSPA 	:=  ::MODELS[I][29]
		X3_CBOXENG 	:=  ::MODELS[I][30]
		X3_PICTVAR 	:=  ::MODELS[I][31]
		X3_WHEN    	:=  ::MODELS[I][32]
		X3_INIBRW  	:=  ::MODELS[I][33]
		X3_GRPSXG  	:=  ::MODELS[I][34]
		X3_FOLDER  	:=  ::MODELS[I][35]
		X3_PYME    	:=  ::MODELS[I][36]
		X3_CONDSQL 	:=  ::MODELS[I][37]
		X3_CHKSQL  	:=  ::MODELS[I][38]
		X3_IDXSRV  	:=  ::MODELS[I][39]
		X3_ORTOGRA 	:=  ::MODELS[I][40]
		X3_IDXFLD  	:=  ::MODELS[I][41]
		X3_TELA    	:=  ::MODELS[I][42]
		X3_AGRUP   	:=  ::MODELS[I][43]
		dbUnLock()

		IF EMPTY(::MODELS[I][44])
			::SETHELP(::MODELS[I][3], OemToAnsi(::MODELS[I][10]))
		ELSE
			::SETHELP(::MODELS[I][3], OemToAnsi(::MODELS[I][44]))
		ENDIF

		IF .NOT. ASCAN(ATABE,{|ATBL| ATBL = ::MODELS[I][1]}) > 0
			AADD(ATABE, ::MODELS[I][1])
		ENDIF

	NEXT

	FOR J := 1 TO LEN(ATABE)
		::UPDTABLE(ATABE[J])
	NEXT

	::OLOG:LINE()

	::MODELS := {}

	RESTAREA(AAREA)

RETURN

/*{ProtheusDoc} UPDSX3:REMOVE

	Remove um campo da SX3 caso ele exista e retorna a ordem do atributo

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD REMOVE(CALIAS, CCAMPO, LATUA) CLASS UPDSX3

	LOCAL BEXISTE := .F.
	LOCAL CORDEM  := "00"
	DEFAULT LATUA := .T.

	DBSELECTAREA("SX3")
	DBSETORDER(1)
	DBGOTOP()
	DBSEEK(AllTrim(CALIAS))

	If Found()
		WHILE .Not. SX3->(EOF()) .and. AllTrim(SX3->X3_ARQUIVO) = AllTrim(CALIAS)
			CORDEM := SX3->X3_ORDEM

			If AllTrim(SX3->X3_CAMPO) == Alltrim(SUBSTR(CCAMPO,1,10))
				BEXISTE:= .T.
				EXIT
			EndIf

			SX3->(DBSkip())
		ENDDO
	EndIf

	//SE O CAMPO EXISTE, ENTÃO DELETA O CAMPO E RETORNA ORDEM
	//SENÃO, RETORNA A ULTIMA ORDEM + 1
	IF BEXISTE
		IF RLOCK()
			DBDELETE()
			MSUNLOCK()

			IF LATUA
				::UPDTABLE(CALIAS)
			ENDIF
		ENDIF
	ELSE
		CORDEM := Soma1(CORDEM)
	ENDIF

RETURN CORDEM

/*{ProtheusDoc} UPDSX3:ADDFILIAL

	ADICIONA UM CAMPO DO TITULO FILIAL
	NO ALIAS

	@developer	fernando.alencar
	@data		20 de MAR�O de 2012
*/
METHOD ADDFILIAL(CALIAS) CLASS UPDSX3

	NTAM := TAMSX3("A1_FILIAL")[1]

	CFILNAME	:= IIF(SUBSTR(CALIAS,1,1) = 'S', SUBSTR(CALIAS,2), CALIAS) + "_FILIAL"
	SX3:ADD(CALIAS)
	SX3:S("CAMPO"	,CFILNAME	)
	SX3:S("TIPO"	,"C"		)
	SX3:S("TAMANHO"	,NTAM		)
	SX3:S("DECIMAL"	,0			)
	SX3:S("PICTURE"	,""			)
	SX3:S("TITULO"	,"FILIAL"	)
	SX3:S("DESCRIC"	,"FILIAL"	)
	SX3:SETFILIAL()

RETURN

/*{ProtheusDoc} UPDSX3:SETFILIAL


	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD SETFILIAL()  CLASS UPDSX3

	SELF:S("USADO", X3_USADO_FILIAL	)
	SELF:S("RESERV", X3_RESERV_FILIAL )
	
RETURN

/*{ProtheusDoc} UPDSX3:SETOPCIONAL

	Seta o campo para estar disponível na enchoice

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD SETOPCIONAL()  CLASS UPDSX3

	SELF:S("USADO", X3_USADO_OPC )
	SELF:S("RESERV", X3_RESERV_OPC )
	
RETURN

/*{ProtheusDoc} UPDSX3:SETCHAVE

	Seta o campo para estar disponível na enchoice e ser obrigatorio

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD SETCHAVE()  CLASS UPDSX3

	SELF:S("USADO", X3_USADO_KEY )
	SELF:S("RESERV", X3_RESERV_KEY	)
	
RETURN

/*{ProtheusDoc} UPDSX3:SETOBR

	Seta o campo para estar disponível na enchoice e ser obrigatório

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD SETOBR()  CLASS UPDSX3

	SELF:S("USADO", X3_USADO_OBR )
	SELF:S("RESERV", X3_RESERV_OBR	)
	
RETURN

/*{ProtheusDoc} UPDSX3:SETNOTUSADO

	Seta o campo como não disponivel na enchoice

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD SETNAOUSADO()  CLASS UPDSX3

	SELF:S("USADO", X3_USADO_NAO )
	SELF:S("RESERV", X3_RESERV_NAO )
	
RETURN

/*{ProtheusDoc} UPDSX3:GETLOGTXT

	Retorna o objeto de log

	@developer	fernando.alencar
	@data		19 de novembro de 2011
*/
METHOD GETLOGTXT()  CLASS UPDSX3
RETURN ::OLOG:LOG()


/*{ProtheusDoc} UPDSX3:UPDTABLE

	Replica no banco as alteracoes feitas na tabela no Dicionario de Dados

	@developer	helitom.silva
	@data		11/05/2012
*/
METHOD UPDTABLE(CTABELA) CLASS UPDSX3

	TcInternal( 25, 'CLOB' )
	X31UpdTable( CTABELA )
	If __GetX31Error()
		MsgAlert(__GetX31Trace())
	EndIf
	TcInternal( 25, 'OFF' )

RETURN


/*{ProtheusDoc} UPDSX3:SETHELP

	Replica no banco as alteracoes feitas na tabela no Dicionario de Dados

	@developer	fernando.alencar
	@data		11/05/2012
*/
METHOD SETHELP(cCampo, cHelp) CLASS UPDSX3

	Local aHelp := {}

	aAdd( aHelp, SubStr( cHelp,  1 , 40 ) )
	aAdd( aHelp, SubStr( cHelp,  41 , 80 ) )
	aAdd( aHelp, SubStr( cHelp,  81 , 120 ) )
	aAdd( aHelp, SubStr( cHelp,  121 , 160 ) )
	aAdd( aHelp, SubStr( cHelp,  161 , 200 ) )
	aAdd( aHelp, SubStr( cHelp,  201 , 240 ) )
	  
	PutHelp( "P" + cCampo, aHelp, aHelp, aHelp, .T. )


RETURN

/*{ProtheusDoc} UPDSX3:REMOVE

	Remove um campo da SX3 caso ele exista e retorna a ordem do atributo

	@developer	helitom.silva
	@data		04 de Outubro de 2012
*/
METHOD REMOVEALL(CALIAS, LATUA) CLASS UPDSX3

	LOCAL BEXISTE := .F.
	DEFAULT LATUA := .T.

	DBSELECTAREA("SX3")
	DBSETORDER(1)
	DBGOTOP()
	DBSEEK(AllTrim(CALIAS))

	IF Found()
		WHILE .Not. SX3->(EOF()) .and. AllTrim(SX3->X3_ARQUIVO) = AllTrim(CALIAS)
			IF RLOCK()
				DBDELETE()
				MSUNLOCK()
			ENDIF

			SX3->(DBSkip())
		ENDDO
		BEXISTE := .T.
	ENDIF

	IF BEXISTE
		IF LATUA
			::UPDTABLE(CALIAS)
		ENDIF
	ENDIF
   
RETURN

/*{ProtheusDoc} UPDSX3:SETORDEM

	Modifica a ordem de um campo da SX3

	@developer	Geanderson S. Silva
	@data		23 de Julho de 2014
*/
METHOD SETORDEM( CALIAS, CCAMPO, CNOVORD ) CLASS UPDSX3

	LOCAL 	LATUA 	:= .F.
	LOCAL 	CCPOTMP	:= ""
	LOCAL	CCPOANT	:= ""	
	LOCAL 	ACAMPOS	:= {}
	LOCAL   CPOSTMP	:= ""
	LOCAL   CPOSATU	:= ""
	LOCAL   CORDATU	:= ""
	LOCAL   NFILTRO	:= 0
	LOCAL   NX, NY	:= 0
	
	DEFAULT CALIAS 	:= ""
	DEFAULT CCAMPO	:= ""
	DEFAULT CNOVORD	:= ""
	
	IF LEN(CNOVORD) < 2
	
		CNOVORD := STRZERO(VAL(CNOVORD),2)
		
	ENDIF

	DBSELECTAREA("SX3")
	SX3->(DBSETORDER(2))
	SX3->(DBGOTOP())	
	IF SX3->(DBSEEK(CCAMPO))	
	
		CORDATU := SX3->X3_ORDEM
		
		IF CNOVORD = CORDATU
		
			RETURN
			
		ENDIF
	
	ELSE
	
		RETURN	
		
	ENDIF
	
	SX3->(DBSETORDER(1))
	SX3->(DBGOTOP())
	IF !SX3->( DBSEEK( AllTrim(CALIAS) + CNOVORD ) )
		
		SX3->(DBSETORDER(2))
		SX3->(DBGOTOP())
		
		IF SX3->(DBSEEK(CCAMPO))
		
		 	SX3->(RLOCK())
		 		SX3->X3_ORDEM 	:= CNOVORD							
				LATUA 			:= .T.
			SX3->(MSUNLOCK())
													
		ENDIF
		
	ELSE	
	
		IF VAL(CORDATU) < VAL(CNOVORD)
		
			NFILTRO := 1 
			
		ELSE
		
			NFILTRO := 2 
			
		ENDIF	
		
		SX3->(DBSETORDER(1))
		SX3->(DBGOTOP())
		IF SX3->(DBSEEK(AllTrim(CALIAS)))
		
			WHILE .Not. SX3->(EOF()) .and. AllTrim(SX3->X3_ARQUIVO) = AllTrim(CALIAS)
			
				If Val(SX3->X3_ORDEM) == Val(CNOVORD) .AND. SX3->X3_RESERV = X3_RES
				
					CNOVORD	:= Soma1(CNOVORD)
					
				ENDIF
				
				If NFILTRO = 1 .AND. Val(SX3->X3_ORDEM) <= Val(CNOVORD)	
				
					AADD( ACAMPOS, { SX3->X3_CAMPO, SX3->X3_ORDEM, SX3->X3_RESERV = X3_RES, } )
					
				ELSEIF NFILTRO = 2 .AND. Val(SX3->X3_ORDEM) >= Val(CNOVORD)	
				
					AADD( ACAMPOS, { SX3->X3_CAMPO, SX3->X3_ORDEM, SX3->X3_RESERV = X3_RES, } )	
								
				EndIf
				
				SX3->(DBSkip())
				
			ENDDO
			
		ENDIF
		
		FOR NX := 1 TO LEN(ACAMPOS)
		 	
		 	CCPOTMP := ACAMPOS[NX][1]
		 	CPOSTMP := ACAMPOS[NX][2]
		 	
	 		IF ACAMPOS[NX][3]	
	 			
				IF	ACAMPOS[NX][2] = CNOVORD
				
					CNOVORD 		:= Soma1(CNOVORD)
					
				ENDIF
				
				IF NFILTRO = 2			
					
					ACAMPOS[NX][4] 	:= ACAMPOS[NX][2]
					
				ENDIF
				
				LOOP
								
			ENDIF
			
			IF NFILTRO = 1
			
				IF ACAMPOS[NX][1] = CCAMPO
						
					SX3->(DBSETORDER(2))
					SX3->(DBGOTOP())
					
					IF SX3->(DBSEEK(CCAMPO))
					
					 	SX3->(RLOCK())
					 		SX3->X3_ORDEM 	:= CNOVORD							
							LATUA 			:= .T.
						SX3->(MSUNLOCK())
																
					ENDIF		
							
				ENDIF
				
			ELSEIF NFILTRO = 2
			
				IF ACAMPOS[NX][2] = CNOVORD .AND. Empty(ACAMPOS[NX][4])	
						
					SX3->(DBSETORDER(2))
					SX3->(DBGOTOP())
					IF SX3->(DBSEEK(CCAMPO))
					
					 	SX3->(RLOCK())
					 		SX3->X3_ORDEM 	:= CNOVORD				 					 		
					 		ACAMPOS[NX][4] 	:= CNOVORD				 				 							
							LATUA 			:= .T.
						SX3->(MSUNLOCK())
						CCPOANT				:= ACAMPOS[NX][1]
						CPOSATU				:= ACAMPOS[NX][2]		
						LOOP				
					ENDIF		
							
				ELSEIF !ACAMPOS[NX][3] .AND. !Empty(CCPOANT)	
							
					SX3->(DBSETORDER(2))
					SX3->(DBGOTOP())
					IF SX3->(DBSEEK(CCPOANT))
					
					 	SX3->(RLOCK())
							SX3->X3_ORDEM 	:= ACAMPOS[NX][2]
							ACAMPOS[NX][4] 	:= CPOSATU					
						SX3->(MSUNLOCK())
						CCPOANT		:= ""
						CPOSATU		:= ""
						
					ENDIF
					
				ENDIF
					
			ENDIF	 
				
		 	FOR NY := 1 TO LEN(ACAMPOS)
		 			 		
		 		IF NFILTRO = 1
		 		
		 			CCPOTMP := ACAMPOS[NY][1] 
		 												
					IF !ACAMPOS[NY][3]
															
						SX3->(DBSETORDER(2))
						SX3->(DBGOTOP())
						IF SX3->(DBSEEK(CCPOTMP)) .AND. ( Alltrim(CCAMPO) <> Alltrim(CCPOTMP) ) .AND. Empty(ACAMPOS[NY][4])
						
							ACAMPOS[NY][4]		:= SX3->X3_ORDEM
						 	SX3->(RLOCK())
								SX3->X3_ORDEM 	:= CPOSTMP							
							SX3->(MSUNLOCK())
							Exit		
											
						ENDIF
																									
					ENDIF
					
				ELSEIF NFILTRO = 2
				
					IF !ACAMPOS[NY][3] .AND. Empty(ACAMPOS[NY][4])
															
						SX3->(DBSETORDER(2))
						SX3->(DBGOTOP())
						IF SX3->(DBSEEK(CCPOTMP)) .AND. ( Alltrim(CCAMPO) <> Alltrim(CCPOTMP) )
										
						 	SX3->(RLOCK())
								SX3->X3_ORDEM 	:= ACAMPOS[NY][2]											
							SX3->(MSUNLOCK())							
							CPOSTMP	:= ACAMPOS[NY][2]
							CCPOTMP	:= ACAMPOS[NY][1]	
													
						ENDIF
						
						ACAMPOS[NY][4] 	:= CPOSTMP
																				
					ENDIF
									
				ENDIF			
				
			NEXT
						
		NEXT

	ENDIF
	   
RETURN