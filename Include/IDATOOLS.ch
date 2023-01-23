#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "SMXFUN.CH"	
#INCLUDE "SDIC.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "ISAMQRY.CH"
#INCLUDE "TBICONN.CH"


//ANTIGO
#DEFINE X3_USADO_EMUSO 		"x       x       x       x       x       x       x       x       x       x       x       x       x       x         x     "
#DEFINE X3_USADO_NAOUSADO 	"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       "
#DEFINE X3_USADO_USADOKEY 	"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       "
#DEFINE X3_OBRIGATORIO 		"x     x         "                 
#DEFINE X3_RESER 			"xxxxxx x        "
#DEFINE X3_RESER_NUMERICO 	"øÇ"
#DEFINE X3_RESERKEY         "     xx         "
#DEFINE X3_RES        		"                "              
#DEFINE X3_RESNAO  			"  xx xx         "

//UTILIZANDO ATÉ O MOMENTO
#DEFINE X3_USADO_FILIAL		"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       "
#DEFINE X3_RESERV_FILIAL	"                "

#DEFINE X3_USADO_KEY		"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x xx    "
#DEFINE X3_RESERV_KEY	    "     xx         "

#DEFINE X3_USADO_OBR		"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     "
#DEFINE X3_RESERV_OBR	    "  x  xx         "

#DEFINE X3_USADO_OPC		"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x x     "
#DEFINE X3_RESERV_OPC	    "  x  x x     x  "

#DEFINE X3_USADO_NAO		"x       x       x       x       x       x       x       x       x       x       x       x       x       x       x       "
#DEFINE X3_RESERV_NAO	    "  x  x x     x  "

/*/{Protheus.doc} IdaTools
@description Neste arquivo sao armazenadas funcoes genericas

@author Helitom Silva
@since  05/06/2012

/*/

/*/{Protheus.doc} IntervalTime
@description Calculo de Horas, minutos e segundos

@author Helitom Silva
@since  11/03/2015

@param p_dDataIni, Data, Data Inicial
@param p_cHoraIni, Hora, Hora Inicial Formato(HH:MM:SS)
@param p_dDataFin, Data, Data Final
@param p_cHoraFin, Hora, Hora Final Formato(HH:MM:SS)
@param p_nTpRet, Numerico, Tipo de Retorno (1 - Horas(HH:MM:SS), 2 - Segundos)

@return uRet, Indefinido, conforme o parametro Tipo de Retorno p_nTpRet podendo ser Horas(HH:MM:SS) ou Segundos

/*/
Static Function IntervalTime(p_dDataIni, p_cHoraIni, p_dDataFin, p_cHoraFin, p_nTpRet)
	
	Local uRet
	Local nSegundos := 0
	Local nDias	    := 0
	Local nDiasTot  := 0
	
	Default p_dDataIni := Date()
	Default p_cHoraIni := Time()
	Default p_dDataFin := Date()
	Default p_cHoraFin := Time()
	Default p_nTpRet   := 1
	
	p_cHoraIni := Transform(PadR(StrTran(p_cHoraIni, ':', ''), 6, '0'), '@R 99:99:99')
	p_cHoraFin := Transform(PadR(StrTran(p_cHoraFin, ':', ''), 6, '0'), '@R 99:99:99')
	
	nDiasTot   := (p_dDataFin - p_dDataIni)
	
	For nDias := 0 to nDiasTot
	
		If nDias = 0
		
			cHoras := ElapTime(p_cHoraIni, Iif(nDiasTot == 0, p_cHoraFin, '24:00:00'))
		
			nSegundos += (Val(SubStr(cHoras, 1, 2)) * 3600) + (Val(SubStr(cHoras, 4, 2)) * 60) + Val(SubStr(cHoras, 7, 2))
		
		ElseIf nDias = nDiasTot
		
			cHoras := ElapTime('00:00:00', p_cHoraFin)
			
			nSegundos += (Val(SubStr(cHoras, 1, 2)) * 3600) + (Val(SubStr(cHoras, 4, 2)) * 60) + Val(SubStr(cHoras, 7, 2))
			
		Else
			nSegundos += (24 * 3600)
		EndIf
		
	Next
	
	If p_nTpRet == 1
		uRet := SubStr(TimeExec(0, nSegundos), 1, 8) 
	ElseIf p_nTpRet == 2
		uRet := nSegundos
	EndIf
		
Return uRet


/*/{Protheus.doc} DFBreak
@description Executa Instrução Break um bloco de Sequence desviando para apos intrução de Recover ou Fim da sequemcia

@author Helitom Silva
@since 17/03/2015

@See (http://tdn.totvs.com/display/framework/BEGIN+SEQUENCE+...+END)

/*/
Static Function DFBreak()
	Break
Return


/*/{Protheus.doc} RetDSX3
@description Retorna Array com dados do dicionario SX3 baseado no nome do campo.

@author Helitom Silva
@since  17/12/2013 

@param p_cCampo, Caracter, Nome do Campo

@return aSX3, Array de dados da SX3.

/*/
Static Function RetDSX3(p_cCampo)
	
	Local aSX3 := {}
	
	DbSelectArea('SX3')
	SX3->(DbSetOrder(2))
	SX3->(DbGoTop())
	
	If SX3->(DbSeek(PadR(p_cCampo, 10)))
		aSX3 := { SX3->X3_TITULO   ,; // 1
                  SX3->X3_CAMPO    ,; // 2
                  Iif(!Empty(SX3->X3_PICTURE), SX3->X3_PICTURE, '@!') ,; // 3
                  SX3->X3_TAMANHO  ,; // 4
                  SX3->X3_DECIMAL  ,; // 5
                  SX3->X3_VALID    ,; // 6 
                  SX3->X3_USADO    ,; // 7
                  SX3->X3_TIPO     ,; // 8
                  SX3->X3_F3       ,; // 9
                  SX3->X3_CONTEXT  ,; // 10
                  SX3->X3_CBOX     ,; // 11
                  SX3->X3_RELACAO  ,; // 12
                  SX3->X3_WHEN     ,; // 13
                  SX3->X3_VISUAL   ,; // 14
                  Iif(Empty(SX3->X3_VLDUSER), '.T.', SX3->X3_VLDUSER) ,; // 15
                  SX3->X3_PICTVAR  ,; // 16
                  Iif(SX3->X3_USADO = X3_USADO_OBR .and. SX3->X3_RESERV = X3_RESERV_OBR, .T., .F.) ,;  // 17
                  SX3->X3_DESCRIC  ,; // 18
                  SX3->X3_NIVEL     } // 19
	Else
		aSX3 := { ''   ,; // 1
                  ''   ,; // 2
                  '@!' ,; // 3
                  0    ,; // 4
                  0    ,; // 5
                  ''   ,; // 6 
                  ''   ,; // 7
                  ''   ,; // 8
                  ''   ,; // 9
                  ''   ,; // 10
                  ''   ,; // 11
                  ''   ,; // 12
                  ''   ,; // 13
                  ''   ,; // 14
                  ''   ,; // 15
                  ''   ,; // 16
                  .F.  ,; // 17
                  ''   ,; // 18
                  1     } // 19
	EndIf          
          	
Return aSX3


/*/{Protheus.doc} IsObject
@description Indica se o objeto foi instanciado ou não
	
@author  Helitom Silva
@since   06/04/2015
@version 1.0		

@param p_oObj, Caracter, Nome da variavel Objeto

/*/
Static Function IsObject(p_oObj) 
	
	Local lRet := .F.
	
	If ValType(p_oObj) = 'C'
		lRet := (Type(p_oObj) == 'O')
	Else
		lRet := (ValType(p_oObj) = 'O')	
	EndIf
	
Return lRet


/*/{Protheus.doc} EndObject
@description Destroi o objeto
	
@author  Helitom Silva
@since   11/07/2017
@version 1.0		

@param p_oObj, Caracter, Nome da variavel Objeto

/*/
Static Function EndObject(p_oObj) 
	
	If IsObject(p_oObj)
		FreeObj(p_oObj)
	EndIf
	
Return


/*/{Protheus.doc} SoNumeros
@description Avaliação se uma string tenha apenas numeros

@author Helitom Silva
@since  05/06/2012

@param p_cString, Caracter, String a ser avaliada.

@return lRet, Logico, Se a string contem apenas numeros retorna .T.

/*/
Static Function SoNumeros(p_cString, p_lAlert)

	Local lRet := .t.
	Local nX   := 0

	Default p_cString := ""
	Default p_lAlert  := .T.

	p_cString := AllTrim(p_cString)

	If .Not. Empty(p_cString)
	
		For nX := 1 to Len(p_cString)
	
			If ! Substr(p_cString, nX, 1) $ '0123456789'
	
				lRet := .f.
				 
				If p_lAlert	
					MsgAlert('Informação invalida, por favor, informe apenas números!')
				EndIf
               
				Exit
				
			EndIf
			
		Next
		
	EndIf

Return lRet


/*/{Protheus.doc} SeleArq
@description Retorna um caminho do arquivo selecionado ou para ser salvo.

@author Helitom Silva
@since  05/06/2012

@param p_cTitulo, Caracter, Titulo da janela.
@param p_cMasc, Caracter, Mascara para aparecer apenas arquivo com extencao especifica. Exemplo: Arquivos csv (*.csv) |*.csv| ou "Arquivos Texto (*.TXT) |*.txt|
@param p_lSalva, Logico, Se .T. mostra botao de salvar senao mostra botao de abrir para selecionar o arquivo.

@return cRet, Caracter, Caminho do arquivo selecionado ou salvo

/*/
Static Function SeleArq(p_cTitulo, p_cMasc, p_lSalva)

	Local cRet := ""

	Default p_cMasc  := "Arquivos Texto (*.TXT) |*.txt|"
	Default p_lSalva := .f.

	/* Declaração de Variaveis Private dos Objetos */
	SetPrvt("oDlg1","oPanel1","oSay1","oGet1","oSBtn1","oBtn1")

	/* Definicao do Dialog e todos os seus componentes */
	oDlg1      := MSDialog():New( 091,232,161,694,p_cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,226,029,.T.,.F. )

	oSay1      := TSay():New( 004,004,{||"Informe o Caminho do Arquivo"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oGet1      := TGet():New( 012,004,{|u| If(PCount()>0,cRet:=u,cRet)},oPanel1,144,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSBtn1     := SButton():New( 011,152,iif(p_lSalva,13,14),{|| (cRet:=cGetFile(p_cMasc,""),oGet1:Refresh())},oPanel1,,"", )
	oBtn1      := TButton():New( 011,188,"OK",oPanel1,{|| oDlg1:End()},030,011,,,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)

Return cRet


/*/{Protheus.doc} Dim
@description Funcao responsavel por manter o Layout independente da resolucao horizontal do Monitor do Usuario.

@author Norbert/Ernani/Mansano
@since  10/05/2005

@param p_nTam, Numerico, Tamanho/Posição a ser refeita.

/*/
Static Function Dim(p_nTam)

	Local nHResH	:=	oMainWnd:nClientWidth	/* Resolucao horizontal do monitor */
	Local nHResV	:=	oMainWnd:nClientHeight	/* Resolucao vertical   do monitor */

	If (nHResH == 776)	/* Resolucao 800x600 */
		p_nTam *= 0.68
	ElseIf (nHResH == 1000)	/* Resolucao 1024x768 */
		p_nTam *= 0.89
	ElseIf (nHResH == 1128)	/* Resolucao 1152x864 */
		p_nTam *= 1
	ElseIf (nHResH == 1256 .And. nHResV == 453)	/* Resolucao 1280x600 */
		p_nTam *= 0.68
	ElseIf (nHResH == 1256 .And. nHResV == 573)	/* Resolucao 1280x720 */
		p_nTam *= 0.88
	ElseIf (nHResH == 1256 .And. nHResV == 621)	/* Resolucao 1280x768 */
		p_nTam *= 0.96
	ElseIf (nHResH == 1256 .And. nHResV == 813)	/* Resolucao 1280x960 */
		p_nTam *= 1
	Else

		If nHResH == 640	/* Resolucao 640x480 (soh o Ocean e o Classic aceitam 640) */  
			p_nTam *= 0.8                                                                
		ElseIf (nHResH == 798) .Or. (nHResH == 800)	/* Resolucao 800x600 */           
			p_nTam *= 1                                                                  
		Else	/* Resolucao 1024x768 e acima */                                           
			p_nTam *= 1.28                                                               
		EndIf                                                                         

	EndIf

	/* ³Tratamento para tema "Flat" */
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			p_nTam *= 0.90
		EndIf
	EndIf
	
Return Int(p_nTam)


/*/{Protheus.doc} ADVParSQL
@description Retorna um filtro SQL, baseado em instrução de filtro ADVPL

@author Helitom Silva
@since  21/08/2012

@param p_cFilADV, Caracter, String com Filtro de sintaxe ADVPL

@return cRet, Caracter, String com filtro de Sintaxe SQL

/*/
Static Function ADVParSQL(p_cFilADV)
	
	Local cRet := p_cFilADV
	
	cRet := StrTran(Upper(cRet)	,".AND."  ," AND ")
	cRet := StrTran(Upper(cRet)	,".OR."   ," OR ")
	cRet := StrTran(cRet       	,"=="     ," = ")
	cRet := StrTran(cRet       	,"!="     ,"<>")
	cRet := StrTran(cRet       	,'"'      ,"'")
	cRet := StrTran(Upper(cRet)	,"ALLTRIM"," ")
	cRet := StrTran(cRet       	,'$'      ," IN ")
	cRet := StrTran(Upper(cRet)	,"DTOS"   ,"")
	cRet := StrTran(cRet		,"->"     ,".")
	
Return cRet


/*/{Protheus.doc} DataExt
@description Retorna Data por extenso

@author Helitom Silva
@since  21/07/2013

@param p_dData, Data, Informação no formato data
@param p_nTipo, Numerico, Determina o tipo do retorno se 1 - Retorna Dia do Mes do Ano, 2 - Mes/Ano

@return cDataExt, Caracter, Data por extenso

/*/
Static Function DataExt(p_dData, p_nTipo)

	Local cData 	  := DtoS(p_dData)	
	Local cDataExt    := ''	
	Local cDia 	  	  := ''
	Local cMes 	  	  := ''
	Local cAno 	  	  := ''
	Local nMes 	  	  := 0
	
	Default p_nTipo := 1
		
	cDia := Extenso(Val(SubStr(cData, 7, 2)), .t.)
	nMes := Val(SubStr(cData, 5, 2))
	
	If p_nTipo == 1
		cAno := Extenso(Val(SubStr(cData, 1, 4)), .t.)	
	Else
		cAno := SubStr(cData, 1, 4)
	EndIf
	
	Do Case
		Case nMes == 1
			cMes := "Janeiro"
		Case nMes == 2
			cMes := "Fevereiro"
		Case nMes == 3
			cMes := "Março"
		Case nMes == 4
			cMes := "Abril"
		Case nMes == 5
			cMes := "Maio"
		Case nMes == 6
			cMes := "Junho"
		Case nMes == 7
			cMes := "Julho"
		Case nMes == 8
			cMes := "Agosto"
		Case nMes == 9
			cMes := "Setembro"
		Case nMes == 10
			cMes := "Outubro"
		Case nMes == 11
			cMes := "Novembro"
		Case nMes == 12
			cMes := "Dezembro"
	EndCase
	
	If p_nTipo == 1
		cDataExt := Upper(cDia + ' de ' + cMes + ' de ' + cAno)
	ElseIf p_nTipo == 2
		cDataExt := Upper(cMes + ' / ' + cAno)
	EndIf
	
Return cDataExt


/*/{Protheus.doc} RetColor
@description Retorna Codido de Cor RGB

@author Helitom Silva
@since  03/08/2013

@param p_nRed, Numerico, Quantidade de Vermelho (0..255)
@param p_nGreen, Numerico, Quantidade de Verde (0..255)
@param p_nBlue, Numerico, Quantidade de Azul (0..255)

@return nRet, Numerico, codigo da cor

/*/
Static Function RetColor(p_nRed, p_nGreen, p_nBlue)

	Local	nRet := 255
	
	Default p_nRed   := 0
	Default p_nGreen := 0
    Default p_nBlue  := 0
   
   	nRet := p_nRed + (p_nGreen * 256) + (p_nBlue * 65536)
   
Return nRet


/*/{Protheus.doc} ArVlCima
@description Arrendondar valor para acima

@author Helitom Silva
@since  03/08/2013

@param p_nValor, Numerico, Valor
@param p_nCasDec, Numerico, Casas decimais

@return nRet, Numerico, Valor arredondado para cima, conforme casas decimais

/*/
Static Function ArVlCima(p_nValor, p_nCasDec)
	
	Local nRet	 	:= 0
	Local cValor 	:= Str(p_nValor)
	Local cInteiro  := Substr(cValor, 1, At('.', cValor) - 1)
	Local cDecimal	:= Substr(cValor, At('.', cValor) + 1)
	
	If Val(cDecimal) > 0
			
		If Len(cDecimal) > p_nCasDec
			cDecimal := If(Val(Substr(cDecimal, p_nCasDec)) > 0, cValToChar(Val(cDecimal) + 1), cValToChar(Val(cDecimal)))
		Else
			cDecimal := Substr(cDecimal, 1, p_nCasDec)
		EndIf
		
	Else
	
		cDecimal := Replicate('0', p_nCasDec)
		
	EndIf
	
	If Val(cDecimal) > Val(Replicate('9', p_nCasDec))		
		cInteiro := cValToChar(Val(cInteiro) + 1)
		cDecimal := Replicate('0', p_nCasDec)
			
		cValor := cInteiro + '.' + cDecimal
	Else
		cValor := cInteiro + '.' + cDecimal
	EndIf
	
	nRet := Val(cValor)
	
Return nRet


/*/{Protheus.doc} Confirm
@description Mensagem de Confirmacao

@author	Helitom Silva
@since  22/08/2013

@param p_p_cMsg, Caracter, Mensagem
@param p_cTitulo, Caracter, Titulo da Tela
@param p_aOpc, Array, Array com dois itens, para identificar os nomes dos botoes exemplo: {'Sim', 'Não'}
@param p_nFocus, Numerico, Qual opcao terá o foco
	 
@return Se .T. se confirmou e .F. se nao confirmou

/*/
Static Function Confirm(p_cMsg, p_cTitulo, p_aOpc, p_nFocus)
	
	Local lRet 	  := .F. 
	Local lSelect := .F.
	
	Default p_cMsg 	  := 'Confirma esta ação?'
	Default p_cTitulo := 'Confirmação'
	Default p_aOpc    := {'&Sim', '&Não'}
	Default p_nFocus  := 1	
		
	/* Declaração de Variaveis Private dos Objetos */                            
	SetPrvt("oDlgConf","oPanConf","oSayConf","oBtnSim","oBtnNao")
	
	/* Definicao do Dialog e todos os seus componentes. */                       
	oDlgConf := MSDialog():New( 091, 233, 201, 544, p_cTitulo,,,.F.,,,,,,.T.,,,.T. )
	oPanConf := TPanel():New( 000, 000, "", oDlgConf,,.F.,.F.,,,158,053,.F.,.F. )
	oSayConf := TSay():New( 012 ,008, {|| p_cMsg},oPanConf,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,020)
	oBtnSim  := TButton():New( 037, 032, p_aOpc[1], oPanConf, {|| lRet:= .T., lSelect := .T.,oDlgConf:End()},045,012,,,,.T.,,"",,,,.F. )
	oBtnNao  := TButton():New( 037, 080, p_aOpc[2], oPanConf, {|| lRet:= .F., lSelect := .T.,oDlgConf:End()},045,012,,,,.T.,,"",,,,.F. )
	
	If p_nFocus == 1
		oBtnSim:SetFocus()
	Else
		oBtnNao:SetFocus()
	EndIf
	
	oDlgConf:Activate(,,,.T., {|| If(!lSelect, (MsgAlert('Selecione uma das duas opções!'), lSelect), lSelect)})

Return (lRet)


/*/{Protheus.doc} TimeExec
@description Demonstração de Tempo de Execução - Esta funcao poderá ser usada para medir o tempo de execução de determinada Rotina, Consulta SQL, calculo e etc..

@author Helitom Silva
@since  27/08/2013

@param p_nSegIni, Numerico, Informe o tempo inicial por meio da função "Seconds()"
@param p_nSegFim, Numerico, Informe o tempo final por meio da função "Seconds()"

@return cRet, Caracter, String com Hora:Minuto:Segundos

/*/
Static Function TimeExec(p_nSegIni, p_nSegFim) 

	Local nHH, nMM , nSS, nMS := (p_nSegFim - p_nSegIni)
	Local cRet := ''
	
	nHH := int(nMS/3600) 
	nMS -= (nHH*3600) 
	nMM := int(nMS/60) 
	nMS -= (nMM*60) 
	nSS := int(nMS) 
	nMS := (nMs - nSS)*1000 
	
	cRet := (cValToChar(nHH) + ":" + StrZero(nMM,2) + ":" + StrZero(nSS, 2) + "." + StrZero(nMS, 3))
	
Return (cRet)


/*/{Protheus.doc} IsProcCall
@description Retorna se uma determinada funcao esta na pilha de Execução.

@author Helitom Silva
@since  02/09/2013

@param p_cRotina, Caracter, Informe a funcao que deseja verificar

@return lRet, Logico, Retorna se .T. se a funcao esta na pilha, senao .F.. 

/*/
Static Function IsProcCall(p_cRotina)

	Local lRet    := .F.
	Local nX      := 1
	Local _cVazio := AllTrim(ProcName(nX))
	
	p_cRotina := Upper(p_cRotina)
	
	While !Empty(_cVazio)
	   If AllTrim(ProcName(nX)) = p_cRotina
	      _cVazio := ''
	      lRet   := .T.
	      Exit
	   Else
	      nX++
	      _cVazio := alltrim(ProcName(nX))
	   EndIf
	End
	
Return lRet


/*/{Protheus.doc} OpenURLP
@description Abre um URL numa tela de browser de Internet dentro do Protheus

@author Helitom Silva
@since  16/09/2013

@param p_cURL, Caracter, URL

@link http://tdn.totvs.com/display/tec/TIBrowser
/*/
Static Function OpenURLP(p_cURL)
 	
 	 Local aTmpSize := MsAdvSize() 
 	 
 	 /*  		---- aTmpSize ----
	 	 1 -> Linha inicial área trabalho.
	     2 -> Coluna inicial área trabalho.
		 3 -> Linha final área trabalho.
		 4 -> Coluna final área trabalho.
		 5 -> Coluna final dialog (janela).
		 6 -> Linha final dialog (janela).
		 7 -> Linha inicial dialog (janela).
	 */	
 
    oDlgURL := MSDialog():New( aTmpSize[7], 0, aTmpSize[6], aTmpSize[5], "Protheus Browser",,,.F.,,,,,,.T.,,,.T. )
     
    oTIBrowser := TIBrowser():New(0, 0, aTmpSize[5] - 640, 262, p_cURL, oDlgURL )
  
    TButton():New( oDlgURL:nHeight - 20, 10, "Imprimir", oDlgURL, {|| oTIBrowser:Print()}, 40, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
             
    oDlgURL:Activate(,,,.T.)

Return


/*/{Protheus.doc} OpenURLB
@description Abre um URL no browser de Internet padrao do Windows.

@author Helitom Silva
@since  16/09/2013

@param p_cURL, Caracter, URL

@link http://tdn.totvs.com/display/tec/TIBrowser
/*/
Static Function OpenURLB(p_cURL)
 	
 	WinExec('CMD /C START ' + p_cURL)
 	 
Return


/*/{Protheus.doc} IdaPutMv
@description Verifica se existe um parametro e cria se necessário

@author Helitom Silva
@since  28/03/2012

@param p_cMvPar, Caracter, Parametro
@param p_cValor, Caracter, Valor do Parametro
@param p_cFilial, Caracter, Filial
@param p_cDesc, Caracter, Descrição do paramento

@return lRet, Logico, .T.

/*/
Static Function IdaPutMv(p_cMvPar, p_cValor, p_cFilial, p_cDesc)

	Local lRet			:= .T.
	Local lExist		:= .F.
	
	Local nRecSX6		:= 0
	Local nOrdSX6		:= 0
	
	Default p_cFilial	:= cFilAnt			/* Sempre tento encontrar primeiro pela filial */
	Default p_cDesc		:= "Atualizar este descricao!"
	
	If Select("SX6") = 0
		DbSelectArea("SX6")
	EndIf
	
	nRecSX6		:= SX6->(Recno())
	nOrdSX6		:= SX6->(IndexOrd())
	
	If Empty(p_cMvPar)
		Return( .F. )
	EndIf
	
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	
	/* Verifico se existe o parametro para a Filial passada ou sem filial */
	If !SX6->(MsSeek( p_cFilial + Substr(p_cMvPar,1,10)))
		If SX6->(MsSeek( Space(Len(AllTrim(p_cFilial))) + Substr(p_cMvPar,1,10)))
			lExist := .T.
		EndIf
	Else
		lExist := .T.
	EndIf
	
	If ( ValType(p_cValor) == 'D' )
		p_cValor 	:= DtoC(p_cValor)
	ElseIf ( ValType(p_cValor) == 'N' )
		xValor	:= cValToChar(p_cValor)
	ElseIf ( ValType(p_cValor) == 'L' )
		xValor	:= If(p_cValor,'.T.','.F.')
	EndIf
	
	If ( lExist )
	
		RecLock('SX6', .F. )
		FieldPut( FieldPos('X6_CONTEUD'), p_cValor ) 
		FieldPut( FieldPos('X6_CONTSPA'), p_cValor ) 
		FieldPut( FieldPos('X6_CONTENG'), p_cValor ) 
		SX6->(MsUnlock())
	
		/* Volta o ponteiro para o local original */
		SX6->(DbSetOrder(nOrdSX6))
		SX6->(DbGoTo(nRecSX6))
	
	Else	
	
		/* Volta o ponteiro para o local original */
		SX6->(DbSetOrder(nOrdSX6))
		SX6->(DbGoTo(nRecSX6))
	
		RecLock('SX6', .T. )
	
		FieldPut( FieldPos('X6_FIL'), p_cFilial ) 
		FieldPut( FieldPos('X6_VAR'), p_cMvPar ) 
		FieldPut( FieldPos('X6_TIPO'), ValType(p_cValor) ) 
		FieldPut( FieldPos('X6_DESCRIC'), Substr(p_cDesc,1,50) ) 
		FieldPut( FieldPos('X6_DESC1'), Substr(p_cDesc,51,50) ) 
		FieldPut( FieldPos('X6_DESC2'), Substr(p_cDesc,101,50) ) 
		FieldPut( FieldPos('X6_DSCSPA'), Substr(p_cDesc,1,50) ) 
		FieldPut( FieldPos('X6_DSCSPA1'), Substr(p_cDesc,51,50) ) 
		FieldPut( FieldPos('X6_DSCSPA2'), Substr(p_cDesc,101,50) ) 
		FieldPut( FieldPos('X6_DSCENG'), Substr(p_cDesc,1,50) ) 
		FieldPut( FieldPos('X6_DSCENG1'), Substr(p_cDesc,51,50) ) 
		FieldPut( FieldPos('X6_DSCENG2'), Substr(p_cDesc,101,50) ) 
		FieldPut( FieldPos('X6_CONTEUD'), p_cValor ) 
		FieldPut( FieldPos('X6_CONTSPA'), p_cValor ) 
		FieldPut( FieldPos('X6_CONTENG'), p_cValor ) 
		FieldPut( FieldPos('X6_PROPRI'), "U" ) 
		FieldPut( FieldPos('X6_PYME'), "S" ) 
		FieldPut( FieldPos('X6_VALID'), "" ) 	
		FieldPut( FieldPos('X6_INIT'), "" ) 
	
		SX6->(MsUnlock())
	
	EndIf

Return lRet


/*/{Protheus.doc} IdaGetMV
@description Pesquisa um parametro, sempre buscando na tabela sx6

@author Helitom Silva
@since  28/03/2012

@param p_cMvPar, Caracter, Parametro
@param p_cDef, Caracter, Valor Default
@param p_cFilial, Caracter, Filial

@return Conteúdo do Parametro ou Valor Default

/*/
Static Function IdaGetMV(p_cMvPar, p_cDef, p_cFilial)

	Local lExist		:= .F.
	
	Local nRecSX6		:= 0
	Local nOrdSX6		:= 0
	
	Local xConteud		:= ""
	Local xTipo			:= ""
	
	Default p_cDef		:= ""
	Default p_cFilial	:= cFilAnt
	
	If Select("SX6") = 0
		DbSelectArea("SX6")
	EndIf
	
	nRecSX6		:= SX6->(Recno())
	nOrdSX6		:= SX6->(IndexOrd())
	
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	
	If !SX6->(MsSeek(p_cFilial + Subs( p_cMvPar, 1, 10)))
		If SX6->(MsSeek( Space(Len(AllTrim(p_cFilial)))+Subs(p_cMvPar,1,10)))
			lExist	:= .T.
		EndIf
	Else
		lExist := .T.
	EndIf
	
	If lExist
	
		xConteud := StrTran(StrTran(SX6->X6_CONTEUD,'"',''),"'","")
		xTipo		:= SX6->X6_TIPO
	
		/* Volta o ponteiro para o local original */
		SX6->(DbSetOrder(nOrdSX6))
		SX6->(DbGoTo(nRecSX6))
	
		Do Case
			Case xTipo = 'C'
				Return( AllTrim(xConteud) )
	
			Case xTipo = 'N'
				If Empty(xConteud)
					Return( 0 )
				Else
					Return( Val(AllTrim(xConteud)) )
				EndIf
	
			Case xTipo = 'L'
				If Upper(AllTrim(xConteud)) $ '.T.|S|VERDADEIRO|TRUE'
					Return( .T. )
				ElseIf Upper(AllTrim(xConteud)) $ '.F.|N|FALSO|FALSE'
					Return( .F. )
				Else
					Return( Nil )
				EndIf
	
			Case xTipo = 'D'
				If Empty(xConteud)
					Return( CtoD("  /  /    ") )
				ElseIf '/' $ xConteud
					Return( CtoD(AllTrim(xConteud)) )
				Else
					Return( StoD(AllTrim(xConteud)) )
				EndIf
	
			OtherWise
			
				Return Nil
	
		EndCase			
	
	Else
	
		/* Volta o ponteiro para o local original */
		SX6->(DbSetOrder(nOrdSX6))
		SX6->(DbGoTo(nRecSX6))
	
		Return p_cDef
	
	EndIf

Return


/*/{Protheus.doc} RetABox
@description converte CBox (SX3) em Array ponto para o objeto da classe TComBox.

@author Helitom Silva
@since  29/12/2013

@param cBox, Caracter, Dados X3_CBOX (Exemplo: S=Sim;N=Não)

@return aBox, Array, Lista com opcoes do Combobox, ponto para o objeto da classe TComBox

/*/
Static Function RetABox(p_cBox)
	
	Local aBox 		:= {}
	Local cItens 	:= "'"
	Local nX		:= 0
	Local cCaracter	:= 0
	
	If !Empty(AllTrim(p_cBox))
		
		For nX := 1 To Len(p_cBox)
			cItens += Iif((cCaracter := SubStr(p_cBox, nX, 1)) = ";", "','", cCaracter)
		Next
		
		cItens += "'"
		
		aBox := &('{' + cItens + '}')
		
	EndIf
	
Return aBox


/*/{Protheus.doc} RNomeEnt
@description Retorna o nome da Entidade do Arquivo XX8

@author Julio Storino
@since  30/11/2012

@param p_nEnt, Numerico, Informe o tipo de retorno ( 0 - Nome do Grupo, 1 - Nome da Unidade de Negocio, 2 - Nome da Empresa, 3 - Nome da Filial ) 

@return cRet, Caracter, Nome desejado conforme parametro p_nEnt

@obs Valores Default p_cEmp=01 p_cFil=01001001 p_cEnt=3

/*/
Static Function RNomeEnt(p_cEmp, p_cFil, p_nEnt)

	Local cRet  	:= ""
	Local nRecXX8	:= XX8->(Recno())
	
	Local nTEmp		:= 0
	Local nTUni		:= 0
	Local nTFil		:= 0
	
	Local cCGrp		:= ""
	Local cCEmp		:= ""
	Local cCUni		:= ""
	Local cCCod		:= ""
	
	Local cNGrp		:=	""
	Local cNUni		:=	""
	Local cNEmp		:=	""
	Local cNFil		:= ""
			
	Default p_cEmp	:= cEmpAnt
	Default p_cFil	:= cFilAnt
	Default p_nEnt	:= 3
	
	XX8->(DbSetOrder(4))
	XX8->(DbGoTop())
	
	/* Localiza primeiro o registro 0 - Grupo de Empresa para pegar a mascara */
	If XX8->(DbSeek(Space(12) + Space(12) + Space(12) + PadR(p_cEmp,12) + '0'))
		_cLay		:= XX8->XX8_LEIAUT
		nTEmp 	:= ContaLet('E',_cLay)
		nTUni 	:= ContaLet('U',_cLay)
		nTFil 	:= ContaLet('F',_cLay)	
	Else
		Return( 'NiHil')
	EndIf
	
	/* Monto as Strings de Procura conforme a entidade. */	
	Do Case
		Case p_nEnt = 0  /* Grupo de Empresa */
			cCGrp	:= Space(12)
			cCEmp 	:= Space(12)
			cCUni	:= Space(12)
			cCCod	:= PadR(p_cEmp, 12)
		Case p_nEnt = 1	/* Unidade de Negocio */
			cCGrp	:= PadR(p_cEmp, 12)
			cCEmp 	:= Space(12)
			cCUni	:= Space(12)
			cCCod	:= PadR(Substr(p_cFil, At('E', cLay), nTEmp), 12)
		Case p_nEnt = 2	/* Empresa */
			cCGrp	:= PadR(p_cEmp, 12)
			cCEmp 	:= PadR(Substr(p_cFil, At('E', cLay), nTEmp), 12)
			cCUni	:= Space(12)
			cCCod	:= PadR(Substr(p_cFil, At('U', cLay), nTUni), 12)
		Case p_nEnt = 3	/* Filial */
			cCGrp	:= PadR(p_cEmp, 12)
			cCEmp 	:= PadR(Substr(p_cFil, At('E', cLay), nTEmp), 12)
			cCUni	:= PadR(Substr(p_cFil, At('U', cLay), nTUni), 12)
			cCCod	:= PadR(Substr(p_cFil, At('F', cLay), nTFil), 12)
		Case p_nEnt > 9
			_cNGrp	:=	U_NOMEENT(p_cEmp, p_cFil, 0)	/* Nome do Grupo */
			_cNUni 	:= If(Empty(PadR(Substr(p_cFil, At('E', cLay), nTEmp), 12)), "", U_NOMEENT(p_cEmp, p_cFil, 1))	/* Nome da Unidade */
			_cNEmp	:= If(Empty(PadR(Substr(p_cFil, At('U', cLay), nTUni), 12)), "", U_NOMEENT(p_cEmp, p_cFil, 2))	/* Nome da Empresa */
			_cNFil	:= If(Empty(PadR(Substr(p_cFil, At('F', cLay), nTFil), 12)), "", U_NOMEENT(p_cEmp, p_cFil, 3))	/* Nome da Filial */
			Do Case
				Case p_nEnt = 10
					cRet   := cNGrp
				Case p_nEnt = 11
					cRet   := cNUni
				Case p_nEnt = 12
					cRet   := cNEmp
				Case p_nEnt = 13
					cRet   := cNFil
			EndCase		
	EndCase
	
	/* Faço a Busca propriamente dita. */
	If p_nEnt < 10
		XX8->(DbGoTop())
		If XX8->(DbSeek(cCGrp + cCEmp + cCUni + cCCod + cValToChar(p_nEnt)))
			cRet   := AllTrim(XX8->XX8_DESCRI)
		Else
			cRet   := 'NiHil'
		EndIf
	EndIf
	
	XX8->(DbGoTo(nRecXX8))

Return cRet


/*/{Protheus.doc} GravLog
@description Grava Logs

@author  Julio Storino
@since   03/11/2007
@version 1.0

@param p_cMsg, Caracter, Mensagem do Log
@param p_cTipo, Caracter, Tipo do Log
@param p_cName, Caracter, Nome do Log

@author  Helitom Silva
@since   20/01/2015
@version 2.0 - Feito tratamento para gravar no system definido no ambiente em execução

/*/
Static Function GravLog(p_cMsg, p_cTipo, p_cName, p_lHelp)

	Local cFile 	 := ''
	Local cDirSys	 := CurDir()
	Local cDirLog	 := '\log\'
	Local cEmailLog	 := GetNewPar('MV_LOGMAIL', '')
	Local lGravLog	 := GetNewPar('IDA_GRVLOG', .F.)
	
	Default p_cMsg   := ''
	Default p_cTipo  := 'FUN'
	Default p_cName  := ''
	Default p_lHelp  := .F.
	
	If lGravLog
	
		/* Verifica se o diretório de Logs existe, senão cria. */
		If !File(cDirLog)
			MakeDir(cDirLog)
		EndIf
		
		/* Verifica se o diretório de Logs existe, senão cria. */
		If !File(cDirLog + p_cTipo)
			MakeDir(cDirLog + p_cTipo)
		EndIf
		
		/* Monta o Nome do arquivo de Log. */
		cFile := p_cTipo
		cFile += '_' + Upper(AllTrim(Funname()))
		cFile += '_' + Upper(SubStr(AllTrim(Iif(Type('cUserName') == 'C', &('cUserName'), '')), 1, 6))
		cFile += '_' + DtoS(Date())
		cFile += '_' + StrTran(Time(), ':', '')
		cFile += '_' + AllTrim(p_cName)
		
		cFile := StrTran(cFile, ':', '')
		
		While File(cDirLog + p_cTipo + '\' + cFile + '.LOG')
			cFile := Left(cFile, Len(cFile) - 2) + StrZero(Val(Right(cFile, 2)) + 1, 2)
		End
		
		cFile += '.LOG'
		
		MemoWrite(cDirLog + p_cTipo + '\' + cFile, p_cMsg)
		MemoWrite('C:\Temp\' + cFile, p_cMsg)
		
		If !Empty(cEmailLog)
			U_IDAMAIL(cEmailLog, 'Log Protheus ' + cFile, p_cMsg)
		EndIf
	
	EndIf
	
	If p_lHelp
		MsgInfo(p_cMsg, p_cTipo)
	EndIf
	
Return


/*/{Protheus.doc} SaveParam
@description Salva Grupo de Perguntas

@author Ary Medeiros
@since  06/06/2014

@param p_cPergunta, Caracter, Nome do Grupo de Perguntas
@param p_aPergunta, Array, Dados da tabela SX1

/*/
Static Function SaveParam(p_cPergunta, p_aPergunta)

	Local nI
	Local nEl 	   := 1
	Local lProfile := .T.
	Local uVar
	Local cProfile := ""
	Local aArray   := {}
	Local lForEmp  := VerSenha(150)
	
	DbSelectArea("SX1")
	DbSeek(p_cPergunta)
	While !Eof() .and. X1_GRUPO = p_cPergunta .And. nEl <= Len(p_aPergunta)
		If p_aPergunta[nEl, 6] == "C"
			uVar := AllTrim(Str(p_aPergunta[nEl, 5]))
		ElseIf p_aPergunta[nEl, 6] == "R"
			uVar := p_aPergunta[nEl, 20]
		ElseIf p_aPergunta[nEl, 6] == "K"
			aArray := &("MV_PAR"+StrZero(nEl, 2, 0))
			uVar   := ""
			For nI := 1 To Len(aArray)
				If aArray[nI, 1]
					uVar+= LTrim(Str(nI)) + ";"
				EndIf
			Next nI
		Else
			If Upper(p_aPergunta[nEl, 2]) == "D"
				uVar := "'" + DTOC(p_aPergunta[nEl, 8], "DDMMYY") + "'"
			ElseIf Upper(p_aPergunta[nEl, 2]) == "N"
				uVar := Str(p_aPergunta[nEl, 8], p_aPergunta[nEl, 3], p_aPergunta[nEl, 4])
			Else
				uVar := p_aPergunta[nEl, 8]
			EndIf
		EndIf
	
		cProfile += X1_TIPO + "#" + X1_GSC + "#" + uVar + CRLF
	
		RecLock("SX1")
		If p_aPergunta[nEl, 6] == "C"
			Replace X1_PRESEL with p_aPergunta[nEl, 5]
		ElseIf p_aPergunta[nEl, 6] == "R"
			Replace X1_CNT02 With uVar
		Else
			Replace X1_CNT01 With uVar
		EndIf
		MSUnlock()
	
		nEl++
		DbSkip()
	
	End
	
	If FindProfDef(cUserName, p_cPergunta, "PERGUNTE", "MV_PAR")
		WriteProfDef(cUserName, p_cPergunta, "PERGUNTE", "MV_PAR", cUserName, p_cPergunta, "PERGUNTE", "MV_PAR", cProfile)
	Else
		WriteNewProf(cUserName, p_cPergunta, "PERGUNTE", "MV_PAR", cProfile)
	EndIf
	
Return


/*/{Protheus.doc} SavePar
@description Atualiza SX1 Antes de Carregar valores Salvos

@author Julio Storino
@since  06/12/2011

@param p_cPergunta, Caracter, Nome do Grupo de Perguntas
@param p_aOrdVal, Caracter, Nome do Grupo de Perguntas

/*/
Static Function SavePar(p_cPergunta, p_aOrdVal)

	Local _nI		:= 0
	Local _aPerg	:= {}
	
	DbSelectArea('SX1')
	DbSetOrder(1)
	
	For _nI := 1 To Len(p_aOrdVal)
		
		DbGoTop()
	
		If DbSeek(PadR(p_cPergunta, 10)+p_aOrdVal[_nI][1])
	
			If SX1->X1_TIPO + SX1->X1_GSC = 'NC'
				aAdd( _aPerg, { X1Pergunt(),                                   	; 	//01-
								X1_TIPO,                                       	;	//02-
							  	IIf(X1_TIPO == "R",255,X1_TAMANHO),         	;	//03-
								X1_DECIMAL,                                		;	//04-
								p_aOrdVal[_nI][2],								;	//05-
								X1_GSC,                                        	;	//06-
								X1_VALID,                                     	;	//07-
								X1_CNT01,                                     	;	//08-
								IIf(X1_GSC=="E",X1_DEF01,AllTrim(X1Def01())),	;	//09-
								AllTrim(X1Def02()),                          	;	//10-
								AllTrim(X1Def03()),                           	;	//11-
								AllTrim(X1Def04()),                          	;	//12-
								AllTrim(X1Def05()),                           	;	//13-
								X1_VAR01,                                     	;	//14-
						  		IIf(X1_PRESEL==0,1,X1_PRESEL),                 	;	//15-
								X1_F3,                                        	;	//16-
								X1_PICTURE,                                   	;	//17-
								IIf(__lPymeSX1,X1_PYME,Nil),                   	;	//18-
								{||.T.},                                      	;	//19-
								X1_CNT02} )											//20-
			Else
				aAdd( _aPerg, { X1Pergunt(),                                   	; 	//01-
								X1_TIPO,                                       	;	//02-
								IIf(X1_TIPO == "R",255,X1_TAMANHO),         	;	//03-
								X1_DECIMAL,                                		;	//04-
								If(X1_PRESEL==0,1,X1_PRESEL),					;	//05-VLR PRE-SELECIONADO COMBO
								X1_GSC,                                        	;	//06-
								X1_VALID,                                     	;	//07-
								p_aOrdVal[_nI][2],                              ;	//08-CONTEUDO ARMAZENADO DO CAMPO
								IIf(X1_GSC == "E", X1_DEF01,AllTrim(X1Def01())),;	//09-
								AllTrim(X1Def02()),                          	;	//10-
								AllTrim(X1Def03()),                           	;	//11-
								AllTrim(X1Def04()),                          	;	//12-
								AllTrim(X1Def05()),                           	;	//13-
								X1_VAR01,                                     	;	//14-
								IIf(X1_PRESEL==0,1,X1_PRESEL),                 	;	//15-
								X1_F3,                                        	;	//16-
								X1_PICTURE,                                   	;	//17-
								IIf(__lPymeSX1,X1_PYME,Nil),                   	;	//18-
								{||.T.},                                      	;	//19-
								X1_CNT02} )											//20-
			EndIf
	
		EndIf
	
		DbSkip()
	
	Next _nI	
	
	SaveParam(p_cPergunta, _aPerg)

Return


/*/{Protheus.doc} PCPFCNPJ
@description Retorna o picture de formatação para CPF ou CNPJ
	
@author  Helitom Silva
@since   21/08/2014
@version 1.0
		
@param p_cCPFCNPJ, Caracter, Numero do CPF ou CNPJ

@return cRet, Caracter, Picture do documento informado

/*/
Static Function PCPFCNPJ(p_cCPFCNPJ)
	
	Local cRet := ''
	
	Default p_cCPFCNPJ := ''
	
	cRet := Iif(Len(p_cCPFCNPJ) > 11, "99.999.999/9999-99", "@R 999.999.999-99")

Return cRet


/*/{Protheus.doc} TCPFCNPJ
@description Formatação para CPF ou CNPJ
	
@author  Helitom Silva
@since   21/08/2014
@version 1.0
		
@param p_cCPFCNPJ, Caracter, Numero do CPF ou CNPJ

@return cRet, Caracter, CPF/CNPJ formatado

/*/
Static Function TCPFCNPJ(p_cCPFCNPJ)
	
	Local cRet := ''
	
	Default p_cCPFCNPJ := ''
	
	
	If Len(Trim(p_cCPFCNPJ)) > 11
		cRet :=	 SubStr(p_cCPFCNPJ, 1, 2) + '.' +  SubStr(p_cCPFCNPJ, 3, 3) + '.' + SubStr(p_cCPFCNPJ, 6, 3) + '/' + SubStr(p_cCPFCNPJ, 9, 4) + '-' + SubStr(p_cCPFCNPJ, 13, 2)
	Else
		cRet :=	 SubStr(p_cCPFCNPJ, 1, 3) + '.' +  SubStr(p_cCPFCNPJ, 4, 3) + '.' + SubStr(p_cCPFCNPJ, 7, 3) + '-' + SubStr(p_cCPFCNPJ, 10, 2)
	Endif


Return cRet


/*/{Protheus.doc} RetDado
@description Retorna dado do tipo informado no parametro
	
@author  Helitom Silva
@since   28/08/2014
@version 1.0		

@return p_cTipo, Caracter, Sigla do Tipo de dados (C = caracter, N = Numerico, D = Data, L = Logico, U = Indefinido)
@return p_nTam, Numerico, Tamanho a Iniciar

/*/
Static Function RetDado(p_cTipo, p_nTam)
	
	Local uRet := Nil
	
	Default p_cTipo := 'C'
	Default p_nTam  := 1
	
	If p_cTipo == 'C'
		uRet := Space(p_nTam)
	ElseIf p_cTipo == 'N'
		uRet := 0
	ElseIf p_cTipo == 'D'
		uRet := CtoD('//')
	ElseIf p_cTipo == 'L'
		uRet := .F.
	EndIf
				
Return uRet


/*/{Protheus.doc} ExistTable
@description Retorna se existe uma tabela no dicionario de dados.
	
@author  Helitom Silva
@since   08/10/2014
@version 1.0		

@return p_cAlias, Caracter, Alias da Tabela a ser verificada

@return lRet, Logico, Se a tabela existir retorna .T.

/*/
Static Function ExistTable(p_cAlias)
	
	Local lRet	   := .F.
	Local aAreaOld := GetArea()
	
	lRet := TCCanOpen(RetSqlName(p_cAlias)) 
	
	RestArea(aAreaOld)
				
Return lRet


/*/{Protheus.doc} EstAll
@description Calcula o saldo de estoque de determinado produto em uma data.

@author Julio Kusther
@since 27/10/2014
@version 1.0

@param p_CodPro, Caracter, Código do produto a ser consultado
@param p_dData, Data, Data do saldo a ser consultado

@return nSaldo, Saldo do produto em todos os locais de estoque
/*/
Static Function	EstAll(p_CodPro,p_dData)
	
	Local nRet			:= 0
	Local cQualy		:= GetNewPar( "MV_CQ", "98")
	
	If !Empty(p_CodPro) .And. !Empty(p_dData)	
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		SB2->(DbSeek( cSeek :=xFilial("SB2") + (p_CodPro)))
	
		While SB2->(!Eof()) .And. SB2->B2_FILIAL+SB2->B2_COD == cSeek 
					
			If SB2->B2_LOCAL = cQualy // Desconsidera o saldo do armazem de qualidade
				SB2->(DbSkip())
				Loop
			EndIf	
									
			nRet	 += CalcEst(p_CodPro,SB2->B2_LOCAL,p_dData)[1]
			SB2->(DbSkip())
		EndDo
		SB2->(DbCloseArea())	
	EndIF						
		
Return(nRet)	


/*/{Protheus.doc} XFJ
@description Retorna mascara de picture campo.

@author Geanderson Silva
@since 15/11/2014
@version 1.0

@param p_cCampo,caracter,Conteudo do campo que será formatado.
@param p_cTipo,caracter, Tipo se pessoa fisica ou Juridica.

@return cMasc, caracter, Marcara do campo CPF ou CNPJ.

/*/
Static Function XFJ(p_cCampo,p_cTipo)

	Local cMasc := ""
	
	Default p_cCampo	:= ""
	Default p_cTipo	:= ""
	
	If !Empty(p_cTipo)	
		If p_cTipo == "1" .or. p_cTipo == "F"  //F/1-CPF e J/2-CNPJ		
			cMasc := "@R 999.999.999-99999%C" //Acrescentados 3 digitos p/ realizar a troca CPF/CNPJ 
		Else
			cMasc := "@R 99.999.999/9999-99%C"
		EndIf
	Else			
		If !Empty(p_cCampo) .And. Len(AllTrim(p_cCampo))<14
			cMasc := "@R 999.999.999-99999%C" //Acrescentados 3 digitos p/ realizar a troca CPF/CNPJ 
		Else
			cMasc := "@R 99.999.999/9999-99%C"
		EndIf	
	EndIf

Return cMasc


/*/{Protheus.doc} BoxSx1
@description Função semelhante a paramBox

@author Julio Kusther
@since 16/12/2014
@version 1.0

/*/
Static Function BoxSx1(aParametros,cTitle,aRet,bOk,aButtons,lCentered,nPosx,nPosy)

	Local nx
	Local oDlg
	Local cPath     := ""
	Local oPanel
	Local oPanelB
	Local cTextSay
	Local lOk			:= .F.
	Local nLinha		:= 8
	Local cArquivos := ""
	Local nBottom
	Local cLoad		:= ProcName(1)+AllTrim(xFilial())
	Local oFntVerdana
	Local oMainWnd		:= GetWndDefault()
	DEFAULT bOk			:= {|| (.T.)}
	DEFAULT aButtons	:= {}
	DEFAULT lCentered	:= .T.
	DEFAULT nPosX		:= 0
	DEFAULT nPosY		:= 0


	DEFINE FONT oFntVerdana NAME "Verdana" SIZE 0, -10 BOLD

	DEFINE MSDialog oDlg TITLE cTitle FROM nPosX,nPosY TO nPosX+274,nPosY+445 OF oMainWnd Pixel

	oPanel := TScrollBox():New( oDlg, 8,10,104,203)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	//oPanel := TPanel():New(8,10,'',oDlg, oDlg:oFont, .F., .F.,, ,203 ,104 ,.T.,.T. )

	For nx := 1 to Len(aParametros)
		Do Case
		Case aParametros[nx][1]==1 // SAY + GET
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := IIF(Empty(aParametros[nx][3]), "",aParametros[nx][3])
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][9],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cWhen	:= Iif(Empty(aParametros[nx][7]),".T.",aParametros[nx][7])
			cValid	:=Iif(Empty(aParametros[nx][5]),".T.",aParametros[nx][5])
			cF3		:=Iif(Empty(aParametros[nx][6]),NIL,aParametros[nx][6])
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf

			&("oGET"+AllTrim(STRZERO(nx,2,0))) := TGet():New( nLinha,95 ,&cBlKGet,oPanel,aParametros[nx][8],,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,,,,,.T.)
		Case aParametros[nx][1]==2 // SAY + COMBO
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cValid	:=Iif(Empty(aParametros[nx][6]),".T.",aParametros[nx][6])
			cBlKVld := "{|| "+cValid+"}"
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlkWhen := "{|| .T. }"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TComboBox():New( nLinha,95, &cBlkGet,aParametros[nx][4], aParametros[nx][5], 10, oPanel, ,,       ,,,.T.,,,.F.,&(cBlkWhen),.T.,,)
		Case aParametros[nx][1]==3 // SAY + RADIO
			nLinha += 8
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cTextSay:= "{||'"+aParametros[nx][2]+" ? "+"'}"
			TGroup():New( nLinha-8,15, nLinha+(Len(aParametros[nx][4])*9)+7,205,aParametros[nx][2]+ " ? ",oPanel,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,.T.)
//			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,,,,,,,)
//			@ nLinha-5,75 TO nLinha+(Len(aParametros[nx][4])*9)+5,80+aParametros[nx][5]+1 LABEl "" of oPanel PIXEL
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlkWhen := "{|| .T. }"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			//cBChange := "{| u | "+aParametros[nx][6]+"}"
						
			                                                   
			&("oGET"+AllTrim(STRZERO(nx,2,0))):= TRadMenu():New( nLinha, 30, aParametros[nx][4],&cBlkGet, oPanel,,/*&(cBChange)*/,,,,,&(cBlkWhen),aParametros[nx][5],9, ,,,.T.)
			nLinha += (Len(aParametros[nx][4])*10)-3
		Case aParametros[nx][1]==4 // SAY + CheckBox
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cTextSay:= "{||'"+aParametros[nx][2]+"  "+"'}"
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][7],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cBlkWhen := "{|| .T. }"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TCheckBox():New(nLinha,95,aParametros[nx][4], &cBlkGet,oPanel, aParametros[nx][5],10,,,,,,,,.T.,,,&(cBlkWhen))
		Case aParametros[nx][1]==5 // CheckBox Linha Inteira
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlkWhen := "{|| .T. }"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TCheckBox():New(nLinha,15,aParametros[nx][2], &cBlkGet,oPanel, aParametros[nx][4],10,,,,,,,,.T.,,,&(cBlkWhen))
		Case aParametros[nx][1]==6 // File + Procura de Arquivo
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][8],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cWhen	    := Iif(Empty(aParametros[nx][6]),".T.",aParametros[nx][6])
			cValid	  := Iif(Empty(aParametros[nx][5]),".T.","("+aParametros[nx][5]+").Or.Vazio("+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+")")
			cBlkGet   := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKVld   := "{|| " + cValid + "}"
			cBlKWhen  := "{|| " + cWhen + "}"
			cArquivos := aParametros[nx][9]
			
			If Len(aParametros[nx]) == 10
				cPath := aParametros[nx][10]
			EndIf
			
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf

			cGetfile := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := cGetFile(cArquivos,'"+;
				"STR0086"+"',0,cPath,"+Iif(Len(aParametros[nX]) < 15 .Or. aParametros[nX][15], ".T.",".F.")+;
				","+IIF(Len(aParametros[nX]) >= 14, AllTrim(Str(GETF_LOCALHARD+GETF_LOCALFLOPPY+aParametros[nX][14])), "0")+;
				")+SPACE(40), If(Empty(MV_PAR"+AllTrim(STRZERO(nx,2,0))+;
				"), MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := '"+;
				aParametros[nx][3]+"',)  }"
	
			
			TGet():New( nLinha,95 ,&cBlKGet,oPanel,aParametros[nx][7],,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .F. ,)
			TButton():New( nLinha,95 + aParametros[nx][7], "STR0085", oPanel,&(cGetFile), 29, 12, , oDlg:oFont, ,.T.,.F.,,.T., &(cBlkWhen),, .F.)
		
		Case aParametros[nx][1]==7 // Filtro de Arquivos
			nLinha += 2
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			SetPrvt("MV_FIL"+AllTrim(STRZERO(nx,2,0)))

			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][4])
			&("MV_FIL"+AllTrim(STRZERO(nx,2,0))) := MontDescr(aParametros[nx][3],ParamLoad(cLoad,aParametros,nx,aParametros[nx][4]))
			TGroup():New( nLinha-8,15, nLinha+40,170,aParametros[nx][2]+ " ? ",oPanel,,,.T.)
			cWhen	:= ".T."
			cValid	:=".T."
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_FIL"+AllTrim(STRZERO(nx,2,0))+","+"MV_FIL"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			cGetFilter := "{|| MV_PAR"+AllTrim(STRZERO(nx,2,0))+" := BuildExpr('"+aParametros[nx,3]+"',,MV_PAR"+AllTrim(STRZERO(nx,2,0))+"),MV_FIL"+AllTrim(STRZERO(nx,2,0))+":=MontDescr('"+aParametros[nx,3]+"',MV_PAR"+AllTrim(STRZERO(nx,2,0))+") }"
			TButton():New( nLinha-2,18, "Editar", oPanel,MontaBlock(cGetFilter), 35, 14, , oDlg:oFont, ,.T.,.F.,,.T., ,, .F.)
			TMultiGet():New( nLinha, 55, &cBlKGet,oPanel,109,33,,,,,,.T.,,.T.,&(cBlkWhen),,,.T.,&(cBlkVld),,.T.,.F., )
			nLinha += 31
		Case aParametros[nx][1]==8 // SAY + GET PASSWORD
			SetPrvt("MV_PAR"+AllTrim(STRZERO(nx,2,0)))
			&("MV_PAR"+AllTrim(STRZERO(nx,2,0))) := ParamLoad(cLoad,aParametros,nx,aParametros[nx][3])
			cTextSay:= "{||'"+STRTRAN(aParametros[nx][2],"'",'"')+" ? "+"'}"
			TSay():New( nLinha, 15 , MontaBlock(cTextSay) , oPanel , ,,,,,.T.,If(aParametros[nx][9],CLR_HBLUE,CLR_BLACK),,,,,,,,)
			cWhen	:= Iif(Empty(aParametros[nx][7]),".T.",aParametros[nx][7])
			cValid	:=Iif(Empty(aParametros[nx][5]),".T.",aParametros[nx][5])
			cF3		:=Iif(Empty(aParametros[nx][6]),NIL,aParametros[nx][6])
			cBlkGet := "{ | u | If( PCount() == 0, "+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+","+"MV_PAR"+AllTrim(STRZERO(nx,2,0))+":= u ) }"
			cBlKVld := "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			If ParamLoad(cLoad,aParametros,0,"1")=="2"
				cBlKWhen := "{|| .F. }"
			EndIf
			TGet():New( nLinha,95 ,&cBlKGet,oPanel,aParametros[nx][8],,aParametros[nx][4], &(cBlkVld),,,, .T.,, .T.,, .T., &(cBlkWhen), .F., .F.,, .F., .T. ,cF3,,,,,.T.)
		EndCase
		nLinha += 17
	Next

	oPanelB := TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,40,20,.T.,.T. )
	oPanelB:Align := CONTROL_ALIGN_BOTTOM
 
	For nx := 1 to Len(aButtons)
		SButton():New( 4, 157-(nx*33), aButtons[nx][1],aButtons[nx,2],oPanelB,.T.,IIf(Len(aButtons[nx])==3,aButtons[nx,3],Nil),)
	Next

	oMainWnd:CoorsUpdate()

	//DEFINE SBUTTON FROM 4, 114   TYPE 4 ENABLE OF oDlg ACTION ParamSave(cLoad,aParametros)
	DEFINE SBUTTON FROM 4, 157   TYPE 1 ENABLE OF oPanelB ACTION (If(ParamOk(aParametros,@aRet).And.Eval(bOk),(oDlg:End(),lOk:=.T.),(lOk:=.F.)))
	DEFINE SBUTTON FROM 4, 190   TYPE 2 ENABLE OF oPanelB ACTION (lOk:=.F.,oDlg:End())

	If (nLinha*2) + 80 > oMAinWnd:nBottom-oMAinWnd:nTop
		nBottom  := oDLg:nTop + oMAinWnd:nBottom-oMAinWnd:nTop - 5
	Else
		nBottom := oDLg:nTop + (nLinha*2) + 80
	EndIf

	nBottom := MAX(310,nBottom)
	oDlg:nBottom := nBottom

	ACTIVATE MSDialog oDlg CENTERED

Return lOk


/*/{Protheus.doc} DiffNumber
@description Calcula a diferença entre dois numeros

@author  Helitom Silva
@since   09/07/2015
@version 1.0

@param p_nNumDiff, Numerico, Numero a ser verificado a diferença.
@param p_nNumBase, Numerico, Numero de referencia.
@param p_nType, Numerico, Indentifica o tipo de calculo se 1 retorna o valor da diferença, se 2 - retorna em percentual.

/*/
Static Function DiffNumber(p_nNumDiff, p_nNumBase, p_nType)
	
	Local nRet := 0
	Local nDif := 0
	
	Default p_nNumDiff := 2
	Default p_nNumBase := 2
	Default p_nType    := 2
	
	nDif := (p_nNumDiff - p_nNumBase)
	
	If p_nNumBase <=  0
		p_nNumBase := Abs(nDif)
	EndIf
	
	If p_nType == 2
		If nDif > 0
			nRet := (Abs(nDif) / p_nNumBase) * 100
		Else
			nRet := (Abs(nDif) / p_nNumBase) * 100 * (-1)
		EndIf
	Else
		nRet := nDif
	EndIf
	
Return nRet


/*/{Protheus.doc} FCONECT
@description Abre uma conexão com o banco sem consumir conexão

@author  Ricardo Tomasi
@author  Kivson Maciel
@author  Fernando Alencar
@version P11 e P10
@since   15/09/2011

@param	 cCodEmp, Caracter, codigo da empresa Opcional
@param 	 cCodFil, Caracter, codigo da filial Opcional

/*/
Static Function FCONECT(cCodEmp, cCodFil)
   
	Local cTipo      := ""
	Local cBanco     := ""
	Local cServer    := ""
	Local cServerIni := ""
	
	Default cCodEmp := "99"
	Default cCodFil := "01"
	
	Static nHndTcp  := -1  
	
	/* Atende protheus 11 */
	cServerIni := "appserver.ini"

	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetPvProfString( "TopConnect", "Database", "", cServerIni )
		cBanco  := GetPvProfString( "TopConnect", "Alias"   , "", cServerIni )
		cServer := GetPvProfString( "TopConnect", "Server"  , "", cServerIni )
	EndIf                                      

	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetPvProfString( "DBAccess", "Database", "", cServerIni )
		cBanco  := GetPvProfString( "DBAccess", "Alias"   , "", cServerIni )
		cServer := GetPvProfString( "DBAccess", "Server"  , "", cServerIni )
	EndIf


	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetSrvProfString( "TopDatabase", "" )
		cBanco  := GetSrvProfString( "TopAlias"   , "" )
		cServer := GetSrvProfString( "TopServer"  , "" )
	EndIf  
	
	/* Atende protheus 10 */
	cServerIni := "totvsappserver.ini"

	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetPvProfString( "TopConnect", "Database", "", cServerIni )
		cBanco  := GetPvProfString( "TopConnect", "Alias"   , "", cServerIni )
		cServer := GetPvProfString( "TopConnect", "Server"  , "", cServerIni )
	EndIf                                      

	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetPvProfString( "DBAccess", "Database", "", cServerIni )
		cBanco  := GetPvProfString( "DBAccess", "Alias"   , "", cServerIni )
		cServer := GetPvProfString( "DBAccess", "Server"  , "", cServerIni )
	EndIf


	If Empty( AllTrim ( cTipo + cBanco + cServer ) )
		cTipo   := GetSrvProfString( "TopDatabase", "" )
		cBanco  := GetSrvProfString( "TopAlias"   , "" )
		cServer := GetSrvProfString( "TopServer"  , "" )
	EndIf  


	nHndTcp := TcLink( cTipo+"/"+cBanco,cServer,7890)

	If nHndTcp < 0 
		UserException("Erro ("+Substr(Str(nHndTcp),1,4)+") ao conectar...")
	EndIf

	Set deleted off
	
	#IFDEF TOP
	    TCInternal( 5, '*OFF' ) /* Desliga Refresh no Lock do Top */
	#ENDIF
	 
	RpcSetType( 2 )
	RpcSetEnv( cCodEmp, cCodFil )

Return .T.


/*/{Protheus.doc} FDESCON
@description Finalizar a coneção corrente

@author  Ricardo Tomasi
@author  Kivson Maciel
@author  Fernando Alencar
@version P11 e P10
@since   20/10/2011
	
/*/
Static Function FDESCON()

	RpcClearEnv()
	Set Deleted On
	TcUnLink(nHndTcp)  
	
Return


/*/{Protheus.doc} CloseAlias
@description Fecha Area (Tabela) caso esteja aberta.

@author Helitom Silva
@since 30/10/2015
@version 1.0

@param p_cAlias, Caracter, Alias da Tabela

/*/
Static Function CloseAlias(p_cAlias)

	Iif(Select(p_cAlias) > 0, (p_cAlias)->(DbCloseArea()), Nil)
	
Return

/*/{Protheus.doc} IdaMsg
@description Exibe log da Geração de Títulos

@author  Helitom Silva
@since   03/11/2016
@version 1.0

@param p_cMsg, Caracter, Logs

/*/
Static Function IdaMsg(p_cMsg, p_cTitulo)

	Local lRet	   := .F.
	Local oFWLayer := FWLayer():New()
	
	Private cInfoMsg := ""
	
	Default p_cMsg   := ""
	Default p_cTitulo := "IdaMsg"
	
	cInfoMsg := p_cMsg
	
	/* Declaração de Variaveis Private dos Objetos */	
	SetPrvt("oFormMsg","oGrpInf", "oMGetLog", "oFntSayMem", "oWinMSGLOG")
	
	oFntSayMem := TFont():New( "Arial",0,-10,,.F.)
	
	/* Definicao do Dialog e todos os seus componentes. */
	oFormMsg := IdaDialog():New( 092, 232, 358, 789, p_cTitulo,,,.F., /*nOr(WS_VISIBLE, WS_POPUP)*/,,,,,.T.,,,,.F.)

	oFWLayer:Init( oFormMsg, .F., .T. )

	oFWLayer:addLine( 'LPRINC', 85, .T. )
	oFWLayer:AddCollumn( 'CMSGLOG', 100, .T., 'LPRINC' )
	oFWLayer:AddWindow( 'CMSGLOG', 'WMSGLOG', '', 100, .F., .T., ,'LPRINC' )

	oWinMSGLOG := oFWLayer:GetColPanel( "CMSGLOG", "LPRINC" ) //oFWLayer:GetWinPanel( 'CMSGLOG', 'WMSGLOG', 'LPRINC' )
	
	oMGetLog := TMultiGet():New( 000, 000, {|u| If(PCount() > 0, cInfoMsg := u, cInfoMsg)}, oWinMSGLOG, oWinMSGLOG:nWidth, oWinMSGLOG:nHeight, oFntSayMem,,CLR_HBLUE,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.T.,.T.,  )
	oMGetLog:Align := CONTROL_ALIGN_ALLCLIENT
	oMGetLog:SetColor(CLR_HBLUE, CLR_WHITE)
	oMGetLog:lReadOnly := .T.

	oFWLayer:addLine( 'LBUTT', 15, .T. )
	oFWLayer:AddCollumn( 'CBUTT', 100, .T., 'LBUTT' )

	oWinButt := oFWLayer:GetColPanel( "CBUTT", "LBUTT" )
		
	oBtnClose  := TButton():New( 003, 230, "&Fechar", oWinButt, {|| oFormMsg:End()}, 050, 015,,,,.T.,,"",,,,.F. )									
		
	oFormMsg:Activate(,,,.T.)

Return


/*/{Protheus.doc} IdaGrvSQL
@description Grava SQL no Terminal

@author  Helitom Silva
@since   22/02/2017
@version 1.0

@param p_cNameFile, Caracter, Nome do SQL
@param p_cSQL, Caracter, Consulta SQL

/*/
Static Function IdaGrvSQL(p_cNameFile, p_cSQL)
	
	Local cFile := ''
	
	Default p_cNameFile := ''
	
	cFile += 'C:\IdaGrvSQL\' + Upper(AllTrim(Funname()))
	cFile += '\' + Upper(AllTrim(p_cNameFile))
	cFile += '_' + Upper(AllTrim(cEmpAnt))
	cFile += '_' + Upper(AllTrim(cFilAnt))
	cFile += '_' + Upper(SubStr(AllTrim(Iif(Type('cUserName') == 'C', &('cUserName'), '')), 1, 6))
	cFile += '_' + DtoS(Date())
	cFile += '_' + StrTran(Time(), ':', '')
	cFile += '.sql'

	MemoWrite(cFile, p_cSQL)
	
Return


/*/{Protheus.doc} iPutSX1
@description Funcao Substituta do PutSX1

@author  Helitom Silva
@since   07/08/2017
@version 1.0 - Copiado do HelpFacil

@param cGrupo, characters, descricao
@param cOrdem, characters, descricao
@param cPergunt, characters, descricao
@param cPerSpa, characters, descricao
@param cPerEng, characters, descricao
@param cVar, characters, descricao
@param cTipo, characters, descricao
@param nTamanho, numeric, descricao
@param nDecimal, numeric, descricao
@param nPresel, numeric, descricao
@param cGSC, characters, descricao
@param cValid, characters, descricao
@param cF3, characters, descricao
@param cGrpSxg, characters, descricao
@param cPyme, characters, descricao
@param cVar01, characters, descricao
@param cDef01, characters, descricao
@param cDefSpa1, characters, descricao
@param cDefEng1, characters, descricao
@param cCnt01, characters, descricao
@param cDef02, characters, descricao
@param cDefSpa2, characters, descricao
@param cDefEng2, characters, descricao
@param cDef03, characters, descricao
@param cDefSpa3, characters, descricao
@param cDefEng3, characters, descricao
@param cDef04, characters, descricao
@param cDefSpa4, characters, descricao
@param cDefEng4, characters, descricao
@param cDef05, characters, descricao
@param cDefSpa5, characters, descricao
@param cDefEng5, characters, descricao
@param aHelpPor, array, descricao
@param aHelpEng, array, descricao
@param aHelpSpa, array, descricao
@param cHelp, characters, descricao

/*/
Static Function iPutSX1(cGrupo, cOrdem, cPergunt, cPerSpa, cPerEng, cVar,; 
     				    cTipo, nTamanho, nDecimal, nPresel, cGSC, cValid,; 
     				    cF3, cGrpSxg, cPyme,; 
     				    cVar01, cDef01, cDefSpa1,cDefEng1,cCnt01,; 
     				    cDef02, cDefSpa2, cDefEng2,; 
     				    cDef03, cDefSpa3, cDefEng3,; 
     				    cDef04, cDefSpa4, cDefEng4,; 
     				    cDef05, cDefSpa5, cDefEng5,; 
    				    aHelpPor, aHelpEng, aHelpSpa, cHelp) 
    				  
	Local aOldArea := GetArea() 
	Local cKey 
	Local lPort    := .f. 
	Local lSpa     := .f. 
	Local lIngl    := .f. 
	
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 
	
	cPyme    := Iif( cPyme   == Nil, " ", cPyme   ) 
	cF3      := Iif( cF3     == NIl, " ", cF3     ) 
	cGrpSxg  := Iif( cGrpSxg == Nil, " ", cGrpSxg ) 
	cCnt01   := Iif( cCnt01  == Nil, "" , cCnt01  ) 
	cHelp    := Iif( cHelp   == Nil, "" , cHelp   ) 
	
	dbSelectArea( "SX1" ) 
	SX1->(dbSetOrder( 1 ))
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes. 
	// RFC - 15/03/2007 
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 
	
	If !( SX1->(DbSeek( cGrupo + cOrdem ))) 
	
	     cPergunt := If(! "?" $ cPergunt .and. ! Empty(cPergunt), Alltrim(cPergunt)+" ?",cPergunt) 
	     cPerSpa  := If(! "?" $ cPerSpa .and. ! Empty(cPerSpa), Alltrim(cPerSpa) +" ?",cPerSpa) 
	     cPerEng  := If(! "?" $ cPerEng .and. ! Empty(cPerEng), Alltrim(cPerEng) +" ?",cPerEng) 
	
	     Reclock( "SX1" , .T. ) 
	
	     Replace X1_GRUPO   With cGrupo 
	     Replace X1_ORDEM   With cOrdem 
	     Replace X1_PERGUNT With cPergunt 
	     Replace X1_PERSPA  With cPerSpa 
	     Replace X1_PERENG  With cPerEng 
	     Replace X1_VARIAVL With cVar 
	     Replace X1_TIPO    With cTipo 
	     Replace X1_TAMANHO With nTamanho 
	     Replace X1_DECIMAL With nDecimal 
	     Replace X1_PRESEL  With nPresel 
	     Replace X1_GSC     With cGSC 
	     Replace X1_VALID   With cValid 
	
	     Replace X1_VAR01   With cVar01 
	
	     Replace X1_F3      With cF3 
	     Replace X1_GRPSXG With cGrpSxg 
	
	     If SX1->(Fieldpos("X1_PYME")) > 0 
	          If cPyme != Nil 
	               Replace X1_PYME With cPyme 
	          Endif 
	     Endif 
	
	     Replace X1_CNT01   With cCnt01 
	     
	     If cGSC == "C"               // Mult Escolha 
	     
	          Replace X1_DEF01   With cDef01 
	          Replace X1_DEFSPA1 With cDefSpa1 
	          Replace X1_DEFENG1 With cDefEng1 
	
	          Replace X1_DEF02   With cDef02 
	          Replace X1_DEFSPA2 With cDefSpa2 
	          Replace X1_DEFENG2 With cDefEng2 
	
	          Replace X1_DEF03   With cDef03 
	          Replace X1_DEFSPA3 With cDefSpa3 
	          Replace X1_DEFENG3 With cDefEng3 
	
	          Replace X1_DEF04   With cDef04 
	          Replace X1_DEFSPA4 With cDefSpa4 
	          Replace X1_DEFENG4 With cDefEng4 
	
	          Replace X1_DEF05   With cDef05 
	          Replace X1_DEFSPA5 With cDefSpa5 
	          Replace X1_DEFENG5 With cDefEng5 
	          
	     Endif 
	
	     Replace X1_HELP With cHelp 
	
	     iPutSX1Help(cKey, aHelpPor, aHelpEng, aHelpSpa) 
	
	     SX1->(MsUnlock())
	     
	Else 
	
	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
	   lSpa  := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA) 
	   lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG) 
	
	   If lPort .Or. lSpa .Or. lIngl 
	   
	          RecLock("SX1", .F.) 
	          
		          If lPort 
		          	SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
		          EndIf
		          
		          If lSpa 
		               SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
		          EndIf 
		          
		          If lIngl 
		               SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
		          EndIf 
	          
	          SX1->(MsUnLock()) 
	          
	     EndIf 
	Endif 
	
	RestArea( aOldArea ) 
    				  
Return


/*/{Protheus.doc} iPutSX1Help
@description Funcao Substituta do PutSX1Help

@author  Helitom Silva
@since   07/08/2017
@version 1.0

@param cKey, characters, descricao
@param aHelpPor, array, descricao
@param aHelpEng, array, descricao
@param aHelpSpa, array, descricao
@param lUpd, logical, descricao
@param cStatus, characters, descricao

/*/
Static Function iPutSX1Help(cKey, aHelpPor, aHelpEng, aHelpSpa, lUpd, cStatus)

	Local cFilePor := "SIGAHLP.HLP"
	Local cFileEng := "SIGAHLE.HLE"
	Local cFileSpa := "SIGAHLS.HLS"
	Local nRet
	Local nT
	Local nI
	Local cLast
	Local cNewMemo
	Local cAlterPath := ''
	Local nPos  
	 
	If ( ExistBlock('HLPALTERPATH') )
	    cAlterPath := Upper(AllTrim(ExecBlock('HLPALTERPATH', .F., .F.)))
	    If ( ValType(cAlterPath) != 'C' )
	        cAlterPath := ''
	    ElseIf ( (nPos:=Rat('\', cAlterPath)) == 1 )
	        cAlterPath += '\'
	    ElseIf ( nPos == 0  )
	        cAlterPath := '\' + cAlterPath + '\'
	    EndIf
	     
	    cFilePor := cAlterPath + cFilePor
	    cFileEng := cAlterPath + cFileEng
	    cFileSpa := cAlterPath + cFileSpa
	     
	EndIf
	 
	Default aHelpPor := {}
	Default aHelpEng := {}
	Default aHelpSpa := {}
	Default lUpd     := .T.
	Default cStatus  := ""
	 
	If Empty(cKey)
	    Return
	EndIf
	 
	If !(cStatus $ "USER|MODIFIED|TEMPLATE")
	    cStatus := NIL
	EndIf
	 
	cLast    := ""
	cNewMemo := ""
	                                                                                                 
	nT := Len(aHelpPor)
	 
	For nI:= 1 to nT
	   cLast := Padr(aHelpPor[nI],40)
	   If nI == nT
	      cLast := RTrim(cLast)
	   EndIf
	   cNewMemo+= cLast
	Next
	 
	If !Empty(cNewMemo)
	    nRet := SPF_SEEK( cFilePor, cKey, 1 )
	    If nRet < 0
	        SPF_INSERT( cFilePor, cKey, cStatus,, cNewMemo )
	    Else
	        If lUpd 
	            SPF_DELETE( cFilePor, nRet ) 
	            SPF_INSERT( cFilePor, cKey, cStatus,, cNewMemo )
	        EndIf                                                           
	    EndIf
	EndIf
	 
	cLast    := ""
	cNewMemo := ""
	 
	nT := Len(aHelpEng)
	 
	For nI:= 1 to nT
	   cLast := Padr(aHelpEng[nI],40)
	   If nI == nT
	      cLast := RTrim(cLast)
	   EndIf
	   cNewMemo+= cLast
	Next
	 
	If !Empty(cNewMemo)
	    nRet := SPF_SEEK( cFileEng, cKey, 1 )
	    If nRet < 0
	        SPF_INSERT( cFileEng, cKey, cStatus,, cNewMemo )
	    Else
	        If lUpd
	            SPF_DELETE( cFileEng, nRet ) 
	            SPF_INSERT( cFileEng, cKey, cStatus,, cNewMemo )
	        EndIf
	    EndIf
	EndIf
	 
	cLast    := ""
	cNewMemo := ""
	 
	nT := Len(aHelpSpa)
	 
	For nI:= 1 to nT
	   cLast := Padr(aHelpSpa[nI],40)
	   If nI == nT
	      cLast := RTrim(cLast)
	   EndIf
	   cNewMemo+= cLast
	Next
	 
	If !Empty(cNewMemo)
	    nRet := SPF_SEEK( cFileSpa, cKey, 1 )
	    If nRet < 0
	        SPF_INSERT( cFileSpa, cKey, cStatus,, cNewMemo )
	    Else
	        If lUpd
	            SPF_DELETE( cFileSpa, nRet ) 
	            SPF_INSERT( cFileSpa, cKey, cStatus,, cNewMemo )
	        EndIf
	    EndIf
	EndIf
	
Return


/*/{Protheus.doc} VisualNF
@description Visualiza Nota Fiscal

@author  Helitom Silva
@since   08/08/2017
@version 1.0

@param p_cTipo, Caracter, Se informar '1' será aberto o documento de entrada, caso contrario documento de saída.
@param p_cFilial, Caracter, Filial onde foi incluído o documento
@param p_cDoc, Caracter, Numero do Documento 
@param p_cSerie, Caracter, Serie do Documento
@param p_cForCli, Caracter, Codigo do Fornecedor ou Cliente
@param p_cLoja, Caracter, Loja do Fornecedor ou Cliente

/*/
Static Function VisualNF(p_cTipo, p_cFilial, p_cDoc, p_cSerie, p_cForCli, p_cLoja)

	Local aRotRec	:= Iif(Type('aRotina') = 'A', aClone(aRotina), Nil)
	
	Private aRotina := {}

	Default p_cTipo    := '' 
	Default p_cFilial  := '' 
	Default p_cDoc     := ''
	Default p_cSerie   := '' 
	Default p_cForCli  := ''
	Default p_cLoja    := ''

	aAdd( aRotina, { "xxx", "xxx", 0, 3, 0, Nil } )
	aAdd( aRotina, { "xxx", "xxx", 0, 2, 0, Nil } )
	
	If p_cTipo == "1"
	
		DbSelectArea('SF1')
        SF1->(DbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
        
        If SF1->(DbSeek(p_cFilial + p_cDoc + p_cSerie + p_cForCli + p_cLoja))

			aRotina[2][1] := "Documento de Entrada"
			aRotina[2][2] := "A103NFiscal"
			aRotina[2][4] := 2
	        
        	A103NFiscal("SF1", SF1->(RecNo()), 2)

        	aRotina := Iif(Type('aRotRec') = 'A', aClone(aRotRec), Nil)
			
		Else
			MsgInfo('Nota Fiscal não encontrada!', 'Informação')
		EndIf
				
	ElseIf p_cTipo == "2"
	
		DbSelectArea('SF2')
        SF2->(DbSetOrder(1)) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
        
        If SF2->(DbSeek(p_cFilial + p_cDoc + p_cSerie + p_cForCli + p_cLoja))
        
        	Mc090Visual("SF2", SF2->(RecNo()), 1)
		
		Else
			MsgInfo('Nota Fiscal não encontrada!', 'Informação')
		EndIf
		
	EndIf

Return