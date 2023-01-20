#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'IDATOOLS.CH'


/*/{Protheus.doc} DBGrid
Esta � a implementacao de uma Grid com Heranca da Classe MsNewGetDados com adi��es de propriedades e eventos.
@type function
@author	Helitom Silva
@since	11/05/2012
/*/
CLASS DBGrid FROM MsNewGetDados

	DATA hHeader    HIDDEN
	DATA hCols 	    HIDDEN
	DATA aColsOri   HIDDEN
	DATA hCheckBox  HIDDEN
	DATA hImgCheck  HIDDEN
	DATA hExecMarc  HIDDEN
	DATA hcOrdem    HIDDEN
	DATA hnOrd 	    HIDDEN
	DATA hlHabReord HIDDEN
	DATA hcExibLeg	HIDDEN
	DATA hnTipEdit  HIDDEN
	DATA hnPosCheck HIDDEN
	DATA hnPosLegen HIDDEN
	DATA hlLegenda  HIDDEN
	DATA haLegenda  HIDDEN
	DATA cRelProgr  HIDDEN
	DATA cRelTitul  HIDDEN
	DATA cRelDescr  HIDDEN
	DATA cRelAlias  HIDDEN 
	DATA aColunaImp HIDDEN
	DATA nLinPos    HIDDEN
	DATA cDirTemp   HIDDEN
	DATA cArqTemp   HIDDEN
	DATA lDestLnPos HIDDEN
	DATA bBackColor HIDDEN
	DATA bFontColor HIDDEN
	DATA cOrigem	HIDDEN
				
	DATA hDepMarc
	DATA hoOk       /* Atributo que tem a imagem de checado */
	DATA hoNo       /* Atributo que tem a imagem de n�o checado */
	DATA hDuplClk   /* Atributo de Duplo Click para quando n�o for usar o CheckBox */
	DATA hVldMarc	/* Valida��o para marca��o do CheckBox quando usar o CheckBox */
	DATA hAnteCriar /* Bloco de codigo que sera executado, antes da criacao da grid */
	DATA hAPosCriar /* Bloco de codigo que sera executado, apos a criacao da grid */
	DATA cReadVar   /* Nome da Vari�vel da Instancia da Classe */
	DATA bChange    /* Bloco de Codigo executado ao mudar de linha */
	
	METHOD CREATE() CONSTRUCTOR
	METHOD CRIARGRID()
	METHOD ANTESCRIAR()   /* Metodo que ser� executado antes de criar, usando o atributo hAnteCriar */
	METHOD APOSCRIAR()    /* Metodo que ser� executado apos criar, usando o atributo hAPosCriar */
	METHOD SETAPOSCRIAR() /* Metodo que ser� executado apos criar, usando o atributo hAPosCriar */
	METHOD MARDESM()
	METHOD CLICKCOL()
	METHOD ATUMEMO()
	METHOD MARCADO()
	METHOD MARCLIN()
	METHOD DEPMARC()
	METHOD DELETADO()
	METHOD SETNOTDEL()
	METHOD SETDEL()
	METHOD DUPLOCLICK()
	METHOD SETDUPCLICK()
	METHOD POSCOLUNA()
	METHOD POSLINHA()
	METHOD GETNUMLINHA()
	METHOD GETHEADCOL()
	METHOD GETCOLCHK() 
	METHOD GETCOLLEG()	
	METHOD GETCOLUNA()
	METHOD NOMECOLUNA()
	METHOD SETCOLUNA()
	METHOD LIMPAR()
	METHOD ADDLINHA()
	METHOD SEEKLINHA()
	METHOD GETQTDLINHA()
	METHOD GETQTDCOLUNA()
	METHOD SETSTATUS()
	METHOD GETLEGENDA()
	METHOD SETLEGENDA()
	METHOD EXIBIRLEG()
	METHOD DIMWND()
	METHOD REFRESH()
	METHOD SETREL()
	METHOD SETCOLIMP()
	METHOD GETCOLIMP()
	METHOD PRINT()
	METHOD REPORTDEF()
	METHOD PRINTREPORT()
	METHOD SETPOPUP()
	METHOD SETFOCUS() 
	METHOD DESTLINPOS() 
	METHOD FILTER()
	METHOD EXECFILTER()
	METHOD GETREADVAR()
	METHOD CREATEALIAS()
	METHOD DELETEALIAS()
	METHOD SETCOLSORI()
	METHOD GETCOLSORI()
	METHOD GETCOLSDIF()
	METHOD SETBACKCOLOR()
	METHOD SETFONTCOLOR()
	METHOD SEARCH()
	METHOD CHGFSEARCH()	
	METHOD GETFSEARCH()
	METHOD RUNSEARCH()
	METHOD SETORIGEM()
	METHOD GETORIGEM()
	METHOD SEARCHORIGEM()
		
ENDCLASS


/*/{Protheus.doc} CREATE
@description Metodo Construtor da Classe

@author	Helitom Silva
@since	11/05/2012

@param p_nCheckBox, Numerico, 0 - para criar a Grid sem a coluna do CheckBox ou 1 - para criar a Grid com a coluna do CheckBox
@param p_nImgCheck, Numerico, 0 - para criar a Grid com imagem checkbox cores  ImgCheck ou 1 - para criar a Grid com imagem checkbox padr�o ImgCheck
@param p_bAposCriar, BlocoDeCodigo, Bloco de codigo que ser� executado ao criar a Grid
@param p_cCamVal, Caracter, Nome do Campo a ser avaiado na cria��o para ja trazer a linha marcada ao criar a grid
@param p_nSinal, Numerico, Numero indentificador do sinal a ser avaliado o campo para marca��o na cria��o da grid, sendo: 1 - Igual(=) | 2 - Diferente(!=) | 3 - Maior(>) | 4 - Menor(<) | 5 - Pertence($)
@param p_uValDef, Indefinido, Valor do campo a ser avaliado para marca��o na cria��o da Grid
@param p_lCheckIni, Numerico, Se .T. a coluna de marca��o ser� apresentada no inicio das colunas, do contrario ao final
@param p_lLegenda, Logico, Se .T. Habilita a apresenta��o da coluna Legenda
@param p_aLegenda, Array, Vetor com as Legendas no formato exemplo: {{"BR_VERMELHO", "Pendente"}, {"BR_VERDE", "Conferido"}, {"BR_PRETO", "Finalizado"}} 
@param p_lLegIni, Logico, Se .T. a legenda ser� apresentada no inicio das colunas, do contrario ao final
@param p_lHabReord, Logico, Se .T. habilita a reordena��o da coluna clicando no Titulo da Coluna
@param p_cDesMarc, Caracter, Descri��o da coluna de Marca��o (CheckBox)
@param p_cDesLeg, Caracter, Descri��o da coluna de Legenda

/*/
METHOD CREATE(p_nTop, p_nLeft, p_nBottom, p_nRight, p_nTipoEdit, p_cLinhaOK, p_cTudoOK, ;
			  p_cIniCpos, p_aAlterGDa, p_nCongelar, p_nMax, p_cFieldOk, p_cSuperDel, p_cDelOk, ;
			  p_oPai, p_aHeader, p_aCols, p_nCheckBox, p_nImgCheck, p_bAposCriar, p_cCamVal, ;
			  p_nSinal, p_uValDef, p_lCheckIni, p_lLegenda, p_aLegenda, p_lLegIni, p_lHabReord, ;
			  p_cDesMarc, p_cDesLeg, p_lDestLnPos) CLASS DBGrid

	Local nPosCpVal  := aScan(p_aHeader, {|__Campo| alltrim(__Campo[2]) = Iif(!Empty(p_cCamVal), p_cCamVal, '')})
	Local lValCam 	 := .F.
	Local nI		 := 0
	Local nL		 := 0
	Local nJ		 := 0
	Local nX		 := 0
	
	Default p_aHeader     := {}	
	Default p_aCols       := {}	
	Default p_nCheckBox   := 0	
	Default p_nImgCheck   := 0
	Default p_nSinal      := 0 /* Sinais: 1 - Igual(=) | 2 - Diferente(!=) | 3 - Maior(>) | 4 - Menor(<) | 5 - Pertence($) */
	Default p_nTipoEdit   := 0
	Default p_lCheckIni   := .T.
	Default p_lLegenda    := .F.
	Default p_aLegenda    := {{"BR_VERDE", "Ativo"}}
	Default p_lLegIni     := .T.
	Default p_lHabReord   := .T.
	Default p_cDesMarc    := 'Status'
	Default p_cDesLeg 	  := 'Legenda'
	Default p_lDestLnPos := .T.
			
	Self:hCheckBox  := p_nCheckBox
	Self:hImgCheck  := p_nImgCheck
	Self:hnTipEdit  := p_nTipoEdit
	Self:hlLegenda  := p_lLegenda
	Self:haLegenda  := p_aLegenda
	Self:hlHabReord := p_lHabReord

	Self:bBackColor := {|| Iif( Self:lDestLnPos .and. Self:nLinPos == Self:nAt, RetColor(132, 185, 217), RetColor(255, 255, 255) ) }
	Self:bFontColor := {|| Iif( Self:lDestLnPos .and. Self:nLinPos == Self:nAt, RetColor(0, 0, 0), RetColor(0, 0, 0) ) }

	Self:SEARCHORIGEM()
		
	If !(p_bAposCriar = Nil)
		Self:hAPosCriar := p_bAposCriar
	EndIf
		
	Self:hHeader := {}
	Self:hCols   := {}
	Self:hoOk	 := Iif(Self:hImgCheck == 1, LoadBitmap(GetResources(), "LBOK"), "BR_VERDE") /* Obtem o tipo de imagem Checado ou Verde */
	Self:hoNo	 := Iif(Self:hImgCheck == 1, LoadBitmap(GetResources(), "LBNO"), "BR_VERMELHO") /* Obtem o tipo de imagem N�o Checado ou Vermelho */
		
	If Self:hCheckBox = 1 .and. p_lCheckIni
		aAdd(Self:hHeader, {p_cDesMarc, "HS_STATUS", "@BMP", 1, 0,"" ,,"C" ,,,,,,"V",,,.F.})
	EndIf
	
	If Self:hlLegenda .and. p_lLegIni
		aAdd(Self:hHeader, {p_cDesLeg, "HS_LEGEND", "@BMP", 1, 0,"" ,,"C" ,,,,,,"V",,,.F.})	
	Endif
		
	/* Cria Novo aHeader para criar a nova DBGrid */
	For nI := 1 to Len(p_aHeader)
		aAdd(Self:hHeader, p_aHeader[nI])
	Next

	If Self:hCheckBox = 1 .and. !p_lCheckIni
		aAdd(Self:hHeader, {p_cDesMarc, "HS_STATUS", "@BMP", 1, 0,"" ,,"C" ,,,,,,"V",,,.F.})
	Endif

	If Self:hlLegenda .and. !p_lLegIni
		aAdd(Self:hHeader, {p_cDesLeg, "HS_LEGEND", "@BMP", 1, 0,"" ,,"C" ,,,,,,"V",,,.F.})	
	Endif
		
	Self:hnPosCheck := Self:POSCOLUNA('HS_STATUS')
	Self:hnPosLegen := Self:POSCOLUNA('HS_LEGEND')
				
	/* Cria Novo aCols para criar a nova DBGrid caso contenha Dados */
	If (Self:hnPosCheck > 0 .or. Self:hnPosLegen > 0)

		If !(Len(p_aCols) > 0)
			
			aAdd(p_aCols, Array(Len(p_aHeader) + 1))
			
			For nX := 1 to Len(p_aHeader)
					
				If p_aHeader[nX][8] == 'C'
					p_aCols[Len(p_aCols)][nX] := Space(p_aHeader[nX][4])
				Else
					p_aCols[Len(p_aCols)][nX] := RetDado(p_aHeader[nX][8])
				EndIf
			
			Next
		
			p_aCols[Len(p_aCols)][Len(p_aHeader) + 1] := .T.
									
		EndIf
		
		If Len(p_aCols) > 0
		
			For nJ := 1 to Len(p_aCols)

				aAdd(Self:hCols, Array(Len(Self:hHeader) + 1))
								
				If Self:hnPosCheck > 0
				
					If (p_nSinal > 0)
			          
						If p_nSinal = 1
							lValCam := (p_uValDef  =  p_aCols[nJ][nPosCpVal])
						ElseIf p_nSinal = 2
							lValCam := (p_uValDef  !=  p_aCols[nJ][nPosCpVal])
						ElseIf p_nSinal = 3
							lValCam := (p_uValDef  >  p_aCols[nJ][nPosCpVal])
						ElseIf p_nSinal = 4
							lValCam := (p_uValDef  <  p_aCols[nJ][nPosCpVal])
						ElseIf p_nSinal = 5
							lValCam := (p_uValDef  $  p_aCols[nJ][nPosCpVal])
						EndIf
			           
					EndIf
			
					If !(p_cCamVal = Nil) .and. !(p_uValDef = Nil) .and. nPosCpVal > 0 .and. !(p_nSinal = Nil)
						Self:hCols[nJ][Self:hnPosCheck] := Iif(lValCam, Self:hoOk, Self:hoNo)
					Else
						Self:hCols[nJ][Self:hnPosCheck] := Self:hoNo
					EndIf
				
				EndIf
				
				If Self:hnPosLegen > 0
					Self:hCols[nJ][Self:hnPosLegen] := Self:haLegenda[1][1]
				EndIF
				
				For nL := 1 to Len(p_aHeader)
					
					Self:hCols[nJ][Self:POSCOLUNA(p_aHeader[nL][2])] := p_aCols[nJ][nL]
					
				Next
				
				Self:hCols[nJ][Len(Self:hHeader) + 1] := p_aCols[nJ][Len(p_aHeader) + 1]
				
			Next
		
		EndIf
		
	Else
		Self:hCols := p_aCols
	EndIf
		
	_Super:New(p_nTop, p_nLeft, p_nBottom, p_nRight, Self:hnTipEdit, p_cLinhaOK, p_cTudoOK,   ;
			   p_cIniCpos, p_aAlterGDa, p_nCongelar, p_nMax, p_cFieldOk, p_cSuperDel, p_cDelOk, ;
			   p_oPai, Self:hHeader, Self:hCols)
	
	Self:oBrowse:bLDblClick   := {|| Iif(Len(Self:aCols) > 0 .and. Len(Self:aCols) >= Self:GETNUMLINHA(), Iif(Self:oBrowse:nColPos = Self:hnPosCheck, Self:MARDESM(0, .T.), Iif(Self:oBrowse:nColPos = Self:hnPosLegen, Self:EXIBIRLEG(), Self:DUPLOCLICK())), Nil)}
	Self:oBrowse:bHeaderClick := {|oObj, nCol| Self:CLICKCOL(nCol)}
	Self:oBrowse:bWhen 	  	  := {|| Iif(Len(Self:aCols) > 0, .T., .F.)}
	Self:oBrowse:bChange 	  := {|| Self:OnChange(), Self:nLinPos := Self:nAt, Self:Refresh()}

	Self:SETPOPUP()
	Self:SETREL(,,, .T.)
		
	Self:hExecMarc := 0
	Self:HcOrdem   := 'A'
	Self:hnOrd     := 0
		
	Self:APOSCRIAR()
	Self:DESTLINPOS(p_lDestLnPos)
	Self:SETBACKCOLOR()
	Self:SETFONTCOLOR()
	
	Self:Refresh()
		
RETURN SELF


/*/{Protheus.doc} MARDESM
@description Metodo Que marca e desmarca o checkBox de uma ou varias linhas

@author	Helitom Silva
@since	11/05/2012

@param p_nTipo, Numerico, Define o tipo de marca��o a ser executando, sendo: 0 - para marcar apenas a linha selecionada ou 1 - para marcar todas as linhas da Grid ou 2 - para desmarcar todas as Linhas da Grid
@param p_lUser, Numerico, Se .T. indica que o metodo esta sendo executado por meio manual do usuario, caso contrario indica que esta sendo executado automatico.

/*/
METHOD MARDESM(p_nTipo, p_lUser) CLASS DBGrid

	Local nOk 	 := 0
	Local nNo 	 := 0
	Local nLin   := 0
	
	Local nGDINSERT := GD_INSERT
	Local nGDUPDATE := GD_UPDATE
	Local nGDDELETE := GD_DELETE
	
	Default p_nTipo := 0
	Default p_lUser := .F.
	
	If p_lUser .and. !(AllTrim(Str(nGDINSERT)) $ AllTrim(Str(Self:hnTipEdit)) .or. ;
					   AllTrim(Str(nGDUPDATE)) $ AllTrim(Str(Self:hnTipEdit)) .or. ; 
					   AllTrim(Str(nGDDELETE)) $ AllTrim(Str(Self:hnTipEdit)) .or. ;
					   Self:hnTipEdit >= 2)
		Return
	EndIf
	
	If p_nTipo = 0
   
		If Self:MARCADO(Self:GETNUMLINHA())
			Self:MARCLIN(Self:GETNUMLINHA(), .F., .T.)
		Else
			
			If (Self:hVldMarc = Nil)
				Self:MARCLIN(Self:GETNUMLINHA(), .T., .T.)
			Else
				If Eval(Self:hVldMarc)
					Self:MARCLIN(Self:GETNUMLINHA(), .T., .T.)
				EndIf
			EndIf
						
		EndIf
	   
	ElseIf p_nTipo = 1
   
		If .not. Self:hExecMarc > 0 /* Esse tratamento � feito porque o evento de clique na coluna executava duas vezes por padrao da MSNEWGETDADOS */
      
			For nLin := 1 To Len(Self:aCols)
				If (Self:aCols[nLin][Len(Self:aHeader) + 1] = .F.)
					If (Self:aCols[nLin][Self:hnPosCheck] == Self:hoOk) .or. (Empty(Self:aCols[nLin][Self:hnPosCheck]))
						nOk++
					Else
						nNo++
					EndIf
				EndIf
			Next
		
			For nLin := 1 To Self:GETQTDLINHA()
				
				Self:POSLINHA(nLin)
				
				If !Self:DELETADO()

					If nOk > nNo
						Self:MARCLIN(nLin, .F., .F.)
					Else

						If (Self:hVldMarc = Nil)
							Self:MARCLIN(nLin, .T., .F.)
						Else
							If Eval(Self:hVldMarc)
								Self:MARCLIN(nLin, .T., .F.)
							EndIf
						EndIf
									
					EndIf					
										
				EndIf
				
			Next
			
			Self:hExecMarc := 1
		 
		Else
	 
			Self:hExecMarc := 0
	   
		EndIf
		
		Self:GoTop()
		    
	ElseIf p_nTipo = 2
   
		For nLin := 1 To Len(Self:aCols)
							
			If (Self:aCols[nLin][Len(Self:aHeader) + 1] = .F.)
				Self:MARCLIN(nLin, .F., .T.)
			EndIf
			
		Next
	   
	EndIf
    
	Self:Refresh()

RETURN


/*/{Protheus.doc} CLICKCOL
@description Metodo que "marca e desmarca o varias linhas" ou no caso das outras colunas "Ordena" (Clique no titulo da coluna)

@author	Helitom Silva
@since	11/05/2012

@param p_nColuna, Numerico, Numero da coluna que recebeu o click

/*/
METHOD CLICKCOL(p_nColuna) CLASS DBGrid

	If p_nColuna > 0
	
		If p_nColuna = Self:hnPosCheck
		
			Self:MARDESM(1, .T.)
			
		ElseIf p_nColuna = Self:hnPosLegen
			
			If Self:hcExibLeg = 0
					
				Self:EXIBIRLEG()
				
				Self:hcExibLeg := 1
			Else
				Self:hcExibLeg := 0
			EndIf
						
		Else
			
			If Self:hlHabReord
			
				If Self:hnOrd = 0
				
					If Self:HcOrdem = 'A'
						aSort(Self:aCols,,,{|mColAnt, mColDep| mColAnt[p_nColuna] > mColDep[p_nColuna]})
						Self:HcOrdem = 'D'
					Else
						aSort(Self:aCols,,,{|mColAnt, mColDep| mColAnt[p_nColuna] < mColDep[p_nColuna]})
						Self:HcOrdem = 'A'
					EndIf
			
					Self:Refresh()
			
					Self:hnOrd := 1
				Else
					Self:hnOrd := 0
				EndIf
				
				If !(Self:bChange == Nil)
					Eval(Self:bChange)
				EndIf
			
			EndIf
			
		EndIf
		
	EndIf

RETURN


/*/{Protheus.doc} ATUMEMO
@description Metodo que atualiza as variaveis de memoria da Grid 

@author	Helitom Silva
@since	14/05/2012

@param p_nColuna, Numerico, Numero da coluna, 0 - Para atualizar todos os campos da memoria ou > 0 - A posicao da coluna na DBGrid.
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()

/*/
METHOD ATUMEMO(p_nColuna, p_lRefresh) CLASS DBGrid

	Local nX	  := 0
	
	Default p_nColuna := 0
	Default p_lRefresh := .T.
	
	If p_lRefresh
		Self:Refresh()
	EndIf
	
	If p_nColuna = 0
		For nX := 1 to LEN(Self:aHeader)	
			If nX != Self:hnPosCheck
				If .not. nX != Self:oBrowse:nColPos
					M->&(Self:aHeader[nX, 2]) := Self:aCols[Self:GETNUMLINHA(), J]
				EndIf
			EndIf
		Next
	Else
		If .not. p_nColuna > Len(Self:aHeader)
			If p_nColuna != Self:hnPosCheck
				M->&(Self:aHeader[p_nColuna, 2]) := Self:aCols[Self:GETNUMLINHA(), p_nColuna]
			EndIf
		EndIf
	EndIf

RETURN


/*/{Protheus.doc} MARCADO
@description Metodo para verifica��o se o checkbox da linha esta marcado. 
     
@author	Helitom Silva
@since	14/05/2012

@param p_nLinha, Numerico, Numero da Linha (Valor default Linha atual).
  	
/*/
METHOD MARCADO(p_nLinha) CLASS DBGrid

	Local lRet := .F.
	
	Default p_nLinha   := Self:GETNUMLINHA()
	
	If Self:GETCOLUNA('HS_STATUS', p_nLinha, Self:hoNo) = Self:hoOk
		lRet := .T.
	EndIf

RETURN lRet


/*/{Protheus.doc} MARCLIN
@description Metodo que marca ou desmarca o checkBox de uma determinada linh  

@author	Helitom Silva
@since  01/06/2012
			
@param p_nLinha, Numerico, O numero da Linha que deseja marcar ou desmarcar  (Valor default Linha atual).
@param p_lMarDesm, Logico,  Informe .T. para marcar ou .F. desmarcar  (Valor default .T.).
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()
			    
/*/
METHOD MARCLIN(p_nLinha, p_lMarDesm, p_lRefresh) CLASS DBGrid

	Default p_nLinha   := Self:GETNUMLINHA()
	Default p_lMarDesm := .T.
	Default p_lRefresh := .T.
	
	If p_nLinha > 0
		
		If !(p_nLinha = Self:GETNUMLINHA())
			Self:POSLINHA(p_nLinha)
		EndIf
		
		If p_lMarDesm
			Self:SETCOLUNA('HS_STATUS', Self:hoOk, p_lRefresh)
		Else
			Self:SETCOLUNA('HS_STATUS', Self:hoNo, p_lRefresh)
		EndIf
		
		If !(Self:hDepMarc = Nil)
			Eval(Self:hDepMarc)
		EndIf		
		
	EndIf
    
RETURN


/*/{Protheus.doc} DEPMARC
@description  Define bloco de codigo a ser executado depois de Marcar Linha

@author  Helitom Silva
@since	  11/08/2014

@param p_bAftMarc, BlocoDeCodigo, Bloco de codigo a executar

/*/
METHOD DEPMARC(p_bAftMarc)  CLASS DBGrid

	Self:hDepMarc := p_bAftMarc
  
RETURN


/*/{Protheus.doc} DUPLOCLICK
@description  Metodo que executa o duplo click quando n�o existe checkbox e tambem esta preenchido o valor para o atributo hDuplClk
    
@author	Helitom Silva
@since	14/01/2013

/*/
METHOD DUPLOCLICK() CLASS DBGrid
	
	If !(Self:hDuplClk = Nil)
		Eval(Self:hDuplClk)
	EndIf

RETURN


/*/{Protheus.doc} CRIARGRID
@description  Metodo executado ao Criar a Grid

@author  Helitom Silva
@since	 11/08/2014

/*/
METHOD CRIARGRID() CLASS DBGrid

	If !(Self:hAPosCriar = Nil)
		Eval(Self:hAPosCriar)
	EndIf

RETURN


/*/{Protheus.doc} ANTESCRIAR
@description  Metodo executado antes de Criar a Grid

@author  Helitom Silva
@since	 11/08/2014

/*/
METHOD ANTESCRIAR() CLASS DBGrid

	If !(Self:hAnteCriar = Nil)
		Eval(Self:hAnteCriar)
	EndIf

RETURN


/*/{Protheus.doc} ANTESCRIAR
@description  Metodo executado ap�s Criar a Grid

@author  Helitom Silva
@since	 11/08/2014

/*/
METHOD APOSCRIAR() CLASS DBGrid

	If !(Self:hAPosCriar = Nil)
		Eval(Self:hAPosCriar)
	EndIf

RETURN


/*/{Protheus.doc} DELETADO
@description Metodo que retorna se a linha esta Deletada  

@author	Helitom Silva
@since	14/05/2012

@param p_nLinha, Numerico, Numero da linha que deseja verificar se foi deletada (Valor default Linha Atual)

/*/
METHOD DELETADO(p_nLinha) CLASS DBGrid

	Local lRet := .F.
	
	Default p_nLinha := Self:GETNUMLINHA()
	
	lRet := Self:aCols[p_nLinha, Len(Self:aHeader) + 1]

RETURN lRet


/*/{Protheus.doc} SETNOTDEL
@description Define linha como n�o deletada

@author  Helitom Silva
@since   28/08/2014

@param p_nLinha, Numerico, Numero da Linha a ser marcada como n�o deletada

/*/
METHOD SETNOTDEL(p_nLinha, p_lRefresh)  CLASS DBGrid
	
	Default p_nLinha   := Self:GETNUMLINHA()
	Default p_lRefresh := .F.
			
	Self:aCols[p_nLinha, Len(Self:aHeader) + 1] := .F.
	
	If p_lRefresh
		Self:Refresh()
	EndIf
	
Return 


/*/{Protheus.doc} SETDEL
@description Marca Linha como Deletada.

@author  Helitom Silva
@since   28/08/2014

@param p_nLinha, Numerico, Numero da Linha a ser marcada como deletada
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()

/*/
METHOD SETDEL(p_nLinha, p_lRefresh)  CLASS DBGrid
	
	Default p_nLinha   := Self:GETNUMLINHA()
	Default p_lRefresh := .F.
			
	Self:aCols[p_nLinha, Len(Self:aHeader) + 1] := .T.
	
	If p_lRefresh
		Self:Refresh()
	EndIf
	
Return 


/*/{Protheus.doc} POSCOLUNA
@description Retorna o numero(posi��o) da coluna

@author  Helitom Silva
@since   19/08/2014

@param p_cColuna, Caracter, Nome do Campo Coluna a ser retornada a posi��o

/*/
METHOD POSCOLUNA(p_cColuna) CLASS DBGrid
	
	Local nRet := 0
	
	Default p_cColuna := ''
	
	nRet := aScan(Self:hHeader, {|X| X[2] = p_cColuna })
	
RETURN nRet


/*/{Protheus.doc} NOMCOLUNA
@description Retorna nome da coluna

@author  Helitom Silva
@since   19/08/2014

@param p_nColuna, Numerico, Numero da Coluna a qual deseja retornar o nome

/*/
METHOD NOMECOLUNA(p_nColuna) CLASS DBGrid
	
	Local cRet := ''
	
	Default p_nColuna := 0
	
	If p_nColuna > 0 .and. p_nColuna <= Self:GETQTDCOLUNA()
		cRet := Self:hHeader[p_nColuna][2]
	EndIf
	
RETURN cRet


/*/{Protheus.doc} POSLINHA
@description Posiciona na linha

@author  Helitom Silva
@since   19/08/2014

@param p_nLinha, Numerico, Indica a linha que deseja posicionar

/*/
METHOD POSLINHA(p_nLinha, p_lRefresh) CLASS DBGrid
	
	Default p_nLinha   := 1
	Default p_lRefresh := .F.
		
	Self:GoTo(p_nLinha)
	
	If p_lRefresh
	
		Self:Refresh()
			
		If !Empty(Self:bChange)
			Eval(Self:bChange)
		EndIf
		
	EndIf
	
RETURN


/*/{Protheus.doc} GETNUMLINHA
@description Retorna numero da linha posicionada

@author  Helitom Silva
@since   18/09/2014

@return nRet, Numerico, Numero da linha posicionada.

/*/
METHOD GETNUMLINHA() CLASS DBGrid
	
	Local nRet
		
	nRet := Self:nAt
	
RETURN nRet


/*/{Protheus.doc} GETHEADCOL
@description Retorna array aHeader de uma Coluna

@author Helitom Silva
@since 18/09/2014

@param p_cColuna, Caracter, Nome do Campo Coluna a ser retornada o aHeader

/*/
METHOD GETHEADCOL(p_cColuna) CLASS DBGrid
	
	Local aRet := Array(20)
	Local nCol := 0
	
	If (nCol := Self:POSCOLUNA(p_cColuna)) > 0
		aRet := Self:hHeader[nCol]
	EndIf
	
RETURN aRet


/*/{Protheus.doc} GETCOLCHK
@description Retorna Numero da Coluna CheckBox

@author Helitom Silva
@since 18/09/2014

@return nRet, Numerico, Numero da Coluna CheckBox

/*/
METHOD GETCOLCHK() CLASS DBGrid
	
	Local nRet := Self:hnPosCheck
	
RETURN nRet


/*/{Protheus.doc} GETCOLLEG
@description Retorna Numero da Coluna Legenda

@author Helitom Silva
@since 18/09/2014

@return nRet, Numerico, Numero da Coluna Legenda

/*/
METHOD GETCOLLEG() CLASS DBGrid
	
	Local nRet := Self:hnPosLegen

RETURN nRet


/*/{Protheus.doc} GETCOLUNA
@description Retorna valor de uma coluna
	
@author  Helitom Silva
@since   28/08/2014
		
@param p_cColuna, Caracter, Nome da coluna
@param p_nLinha, Numerico, Numero da linha da Grid a ser retornado o valor da coluna
@param p_uDefault, Indefinido, Valor Default de retorno, caso n�o exista Valor.

@return p_uValor, Indefinido, Valor da coluna

/*/
METHOD GETCOLUNA(p_cColuna, p_nLinha, p_uDefault) CLASS DBGrid
	
	Local uRet 		  := p_uDefault
	Local nNumCol	  := 0
		
	Default p_cColuna  := ''
	Default p_nLinha   := Self:GETNUMLINHA()
	
	p_nLinha := Iif(p_nLinha > Self:GETQTDLINHA(), Self:GETQTDLINHA(), p_nLinha)
	
	nNumCol := Self:POSCOLUNA(p_cColuna)
	
	If nNumCol > 0 .and. nNumCol <= Len(Self:hHeader)			
		uRet := Self:aCols[p_nLinha, Self:POSCOLUNA(p_cColuna)]
	EndIf
	
	If ValType(uRet) == 'U'
		uRet := RetDado(Self:GETHEADCOL(p_cColuna)[8])
	EndIf
	
RETURN uRet


/*/{Protheus.doc} SETCOLUNA
@description Define valor para coluna
	
@author  Helitom Silva
@since   28/08/2014
		
@param p_cColuna, Caracter, Nome da coluna
@param p_uValor, Indefinido, Valor a ser definido na coluna
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()
@param p_nLinha, Numerico, Numero da linha da Grid a alterar a coluna

/*/
METHOD SETCOLUNA(p_cColuna, p_uValor, p_lRefresh, p_nLinha) CLASS DBGrid
	
	Local nNumCol	   :=  0
	
	Default p_cColuna  := ''
	Default p_lRefresh := .F.
	Default p_nLinha   := Self:GETNUMLINHA()
	
	nNumCol := Self:POSCOLUNA(p_cColuna)
	
	If (nNumCol > 0 .and. nNumCol <= Len(Self:hHeader)) .and. (p_nLinha > 0 .and. p_nLinha <= Len(Self:aCols))
		Self:aCols[p_nLinha, nNumCol] := p_uValor
		Self:ATUMEMO(nNumCol, p_lRefresh)
	EndIf
	
	If p_lRefresh
		Self:Refresh()
	EndIf
	
RETURN


/*/{Protheus.doc} LIMPAR
@description Limpa a Grid, apagando todas as Linhas
	
@author  Helitom Silva
@since   28/08/2014
		
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()

/*/	
METHOD LIMPAR(p_lRefresh) CLASS DBGrid
	
	Default p_lRefresh := .T.
	
	aSize(Self:aCols, 0)
	
	If p_lRefresh
		Self:Refresh()
	EndIf
		
RETURN


/*/{Protheus.doc} ADDLINHA
@description Adiciona Linha Vazia
	
@author  Helitom Silva
@since   28/08/2014

/*/
METHOD ADDLINHA() CLASS DBGrid
	
	Local nRet := 0
	Local nX   := 0
	
	aAdd(Self:aCols, Array(Len(Self:aHeader) + 1))
	
	nRet := Len(Self:aCols)
	
	Self:PosLinha(nRet)
	
	For nX := 1 to Len(Self:aHeader)
		
		If !(nX == Self:hnPosCheck .or. nX == Self:hnPosCheck)
			
			If Self:aHeader[nX][8] == 'C'
				Self:SetColuna(Self:aHeader[nX][2], Space(Self:aHeader[nX][4]), .F.)
			Else
				Self:SetColuna(Self:aHeader[nX][2], RetDado(Self:aHeader[nX][8]), .F.)
			EndIf
			
		EndIf
		
	Next
	
	Self:SETSTATUS(.F., .F.)
	Self:SETLEGENDA(1, .F.)
	Self:SETNOTDEL(nRet, .F.)
		
RETURN nRet


/*/{Protheus.doc} SEEKLINHA
@description Procura linha
	
@author  Helitom Silva
@since   18/09/2014

@param p_cColuna, Caracter, Nome da coluna
@param p_uValor, Indefinido, Valor a ser definido na coluna
@param p_lPosicio, Logico, Define se posiciona na Linha encontrada

@param p_nLinha, Numerico, Indica a linha encontrada

/*/
METHOD SEEKLINHA(p_cColuna, p_uValor, p_lConsDel, p_lPosicio) CLASS DBGrid
	
	Local nRet    := 0
	Local nX   	  := 0
	Local nLinOld := Self:GetNumLinha()
	Local nPosCol := 0
	 	
	Default p_cColuna  := ''
	Default p_lConsDel := .T.
	Default p_lPosicio := .F.
	
	nPosCol := Self:POSCOLUNA(p_cColuna)
	
	If !(ValType(p_uValor) == 'U') .and. nPosCol > 0
		
		If ValType(p_uValor) == 'C'
			nRet := aScan(Self:aCols, {|X| SubStr(X[nPosCol], 1, Len(AllTrim(p_uValor))) = AllTrim(p_uValor) .and. Iif(p_lConsDel, .T., !X[Len(X)])})
		Else
			nRet := aScan(Self:aCols, {|X| X[nPosCol] = p_uValor .and. Iif(p_lConsDel, .T., !X[Len(X)])})		
		EndIf
		
	EndIf
	
	If p_lPosicio .and. nRet > 0
		Self:POSLINHA(nRet, .T.)
	Else
		Self:POSLINHA(nLinOld, .T.)
	EndIf
	
RETURN nRet


/*/{Protheus.doc} GETQTDLINHA
@description Retorna a quantidade de Linha.
	
@author  Helitom Silva
@since   28/08/2014

@param p_lDeletado, Logico, Indica se retorna a quantidade de linhas incluindo as deletadas
@param p_lMarcado, Logico, Indica se retorna a quantidade de linhas marcados

/*/
METHOD GETQTDLINHA(p_lDeletado, p_lMarcado) CLASS DBGrid
	
	Local nRet  := Len(Self:aCols)
	Local nDel  := 0
	Local nMarc := 0
	
	Default p_lDeletado := .T.
	Default p_lMarcado  := .F.
	
	aEval(Self:aCols, {|X| nDel  += Iif(X[Len(Self:aHeader) + 1], 1, 0)})
	aEval(Self:aCols, {|X| nMarc += Iif(Self:GETCOLCHK() > 0, Iif(X[Self:GETCOLCHK()] == Self:hoOk, 1, 0), 0)})
	
	If !p_lDeletado
		nRet := (nRet - nDel)
	EndIf
	
	If p_lMarcado
		nRet := nMarc
	EndIf
	
RETURN nRet


/*/{Protheus.doc} GETQTDCOLUNA
@description Retorna a quantidade de Colunas.
	
@author  Helitom Silva
@since   28/08/2014

/*/
METHOD GETQTDCOLUNA() CLASS DBGrid
	
	Local nRet := 0
	
	nRet := Len(Self:aHeader)
	
RETURN nRet


/*/{Protheus.doc} SETDUPCLICK
@description Define bloco de codigo para ser executado no Duplo Click nas linhas da Grid

@author  Helitom Silva
@since   27/08/2014

@param p_bDupClick, BlocoDeCodigo, Bloco de Codigo do Evento do Duplo Click

/*/
METHOD SETDUPCLICK(p_bDupClick) CLASS DBGrid
	
	If !(p_bDupClick = Nil)
		Self:hDuplClk := p_bDupClick
	EndIf
	
Return


/*/{Protheus.doc} SETSTATUS
@description Define Status

@author	Helitom Silva
@since  01/06/2012
			    
/*/
METHOD SETSTATUS(p_lMarDesm, p_lRefresh, p_nLinha) CLASS DBGrid

	Default p_lMarDesm := .T.
	Default p_lRefresh := .T.
	Default p_nLinha   := Self:GETNUMLINHA()
	
	If p_nLinha > 0
		
		If !(p_nLinha = Self:GETNUMLINHA())
			Self:POSLINHA(p_nLinha)
		EndIf
		
		If p_lMarDesm
			Self:SETCOLUNA('HS_STATUS', Self:hoOk, p_lRefresh)
		Else
			Self:SETCOLUNA('HS_STATUS', Self:hoNo, p_lRefresh)
		EndIf
		
	EndIf
    
RETURN


/*/{Protheus.doc} GETLEGENDA
@description Retorna Numero da Legenda Atual da Linha atual
	
@author  Helitom Silva
@since   27/08/2014

@return nRet, Numerico, Numero da Legenda da Linha Atual

/*/
METHOD GETLEGENDA() CLASS DBGrid
	
	Local nRet := aScan(Self:haLegenda, {|X| X[1] = Self:aCols[Self:GETNUMLINHA()][Self:hnPosLegen]})
	
RETURN nRet


/*/{Protheus.doc} SETLEGENDA
@description Define Numero da Legenda da linha Atual

@author  Helitom Silva
@since   27/08/2014

@param p_nLegenda, Numerico, Numero da legenda a definir
@param p_lRefresh, Logico, Determina se executa o metodo Refresh()

/*/
METHOD SETLEGENDA(p_nLegenda, p_lRefresh, p_nLinha) CLASS DBGrid
	
	Default p_nLegenda := 1
	Default p_lRefresh := .F.
	Default p_nLinha   := Self:GETNUMLINHA()
	
	If p_nLegenda <= Len(Self:haLegenda)
	
		Self:SETCOLUNA('HS_LEGEND', Self:haLegenda[p_nLegenda][1], p_lRefresh)
	
	EndIf

RETURN


/*/{Protheus.doc} EXIBIRLEG
@description Exibe dialogo com as Legendas da Grid
	
@author  Helitom Silva
@since   27/08/2014

/*/
METHOD EXIBIRLEG() CLASS DBGrid
	
	Local nCont 	:= 0
	Local nLiChbox  := 4	
	Local nLiFimDlg := 165
	
	SetPrvt("oDlgFilLeg", "oSBtnOK")
		
	oDlgFilLeg := MSDialog():New( Self:DIMWND(091), Self:DIMWND(228), Self:DIMWND(138), Self:DIMWND(616),"Legenda",,,.F.,,,,,,.T.,,,.T. )
	 
	For nCont := 1 to Len(Self:haLegenda)

		If nCont > 1
			nLiChbox += 10
			nLiFimDlg += 19
		EndIf				
           
    	&('oBmp' + cValToChar(nCont))  := TBitmap():New(Self:DIMWND(nLiChbox), Self:DIMWND(014), Self:DIMWND(008), Self:DIMWND(008), , Self:haLegenda[nCont][1], , oDlgFilLeg,,,,,,,,,.T.)
              			
		&('oSay' + cValToChar(nCont)) := TSay():New( Self:DIMWND(nLiChbox+1),Self:DIMWND(024), {|| ''},oDlgFilLeg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
		&('oSay' + cValToChar(nCont)):SetText( Self:haLegenda[nCont][2] )
		
	Next	
	
	oDlgFilLeg:nBottom := Self:DIMWND(nLiFimDlg)
	oDlgFilLeg:Activate(,,,.T.)
   
RETURN


/*/{Protheus.doc} DIMWND
@description Retorna posi��o em pixels  dimencionada
	
@author  Helitom Silva
@since   27/08/2014
		
@param p_nTam, Numerico, posi��o em pixels a ser dimencionada

/*/
METHOD DIMWND(p_nTam) CLASS DBGrid
	
	Local nHResH	:=	oMainWnd:nClientWidth	/* Resolucao horizontal do monitor */
	Local nHResV	:=	oMainWnd:nClientHeight	/* Resolucao vertical   do monitor */
	
	If (nHResH == 776)	/* Resolucao 800x600 */
		p_nTam *= 0.68
	ElseIf (nHResH == 1000)	/* Resolucao 1024x768 */
		p_nTam *= 0.89
	ElseIf (nHResH == 1128)	/* Resolucao 1152x864 */
		p_nTam *= 1
	ElseIf (nHResH == 1256 .and. nHResV == 453)	/* Resolucao 1280x600 */
		p_nTam *= 0.68
	ElseIf (nHResH == 1256 .and. nHResV == 573)	/* Resolucao 1280x720 */
		p_nTam *= 0.88
	ElseIf (nHResH == 1256 .and. nHResV == 621)	/* Resolucao 1280x768 */
		p_nTam *= 0.96
	ElseIf (nHResH == 1256 .and. nHResV == 813)	/* Resolucao 1280x960 */
		p_nTam *= 1
	Else	/* Resolucao 1280x1024 */
		p_nTam *= 1
	EndIf

	/* Tratamento para tema "Flat" */
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			p_nTam *= 0.90
		EndIf
	EndIf
	
RETURN Int(p_nTam)


/*/{Protheus.doc} REFRESH
@description Executa atualiza��o da interface da Grid

@author Helitom Silva
@since  19/09/2014

/*/
METHOD REFRESH() CLASS DBGrid

	Local nLinAtu := Self:GETNUMLINHA()
	
	Self:oBrowse:Refresh()
	
	Self:PosLinha(nLinAtu)
	
	Self:SetFocus()
	Self:oBrowse:NextControl():SetFocus()
	
RETURN


/*/{Protheus.doc} SETREL
@description Define dados do Relat�rio

@author Helitom Silva
@since  07/11/2014

@param p_cRelProgr, Caracter, Programa de origem do relat�rio
@param p_cRelTitul, Caracter, Titulo do Relat�rio
@param p_cRelDescr, Caracter, Descri��o do Relat�rio
@param p_lColImp, Logico, Se .T. Define ou Redefine as Colunas de Impress�o


/*/
METHOD SETREL(p_cRelProgr, p_cRelTitul, p_cRelDescr, p_lColImp) CLASS DBGrid
	
	Local nX 	  := 0
	Local oDlgDef := GetWndDefault()
	
	Default p_cRelProgr := Self:GetOrigem()
	Default p_cRelTitul := Iif(!Empty(AllTrim(oDlgDef:cCaption)), AllTrim(oDlgDef:cCaption), 'Relat�rio de Dados da Grid')
	Default p_cRelDescr := Iif(!Empty(AllTrim(oDlgDef:cCaption)), AllTrim(oDlgDef:cCaption), 'Rela��o de Dados da Grid')
	Default p_lColImp   := .F.
	
	Self:cRelProgr  := p_cRelProgr
	Self:cRelTitul  := p_cRelTitul
	Self:cRelDescr  := p_cRelDescr
	
	If ValType(Self:aColunaImp) == 'U'
		Self:aColunaImp := {}
	EndIf
	
	If p_lColImp
		
		Self:aColunaImp := {}
		
		For nX := 1 to Self:GETQTDCOLUNA()
			
			Self:SETCOLIMP(Self:NOMECOLUNA(nX))
			
		Next
		
	EndIf
	
RETURN


/*/{Protheus.doc} SETCOLIMP
@description Define configuracao de impressao da coluna

@author Helitom Silva
@since  07/11/2014

@param p_cColuna, Caracter, Nome da Coluna
@param p_lImprime, Logico, Se .T. Indica que ser� apresentada a coluna no relatorio, caso contrario n�o ser� apresentada
@param p_lImpTotal, Logico, Se .T. Indica que ser� feito a totaliza��o da coluna
@param p_nTpTotal, Numerico, Se 1 - Indica que ser� feito a a contagem nos totais da coluna e 2 - 1 - Indica que ser� feito a a soma nos totais da coluna.

/*/
METHOD SETCOLIMP(p_cColuna, p_lImprime, p_lImpTotal, p_nTpTotal) CLASS DBGrid

	Local nPosImp := 0
	
	Default p_cColuna   := ''
	Default p_lImprime  := .T.
	Default p_lImpTotal := .F.
	Default p_nTpTotal  := 1
	
	nPosImp := aScan(Self:aColunaImp, {|X| X[1] = p_cColuna})
	
	If !(nPosImp > 0)
		aAdd(Self:aColunaImp, {p_cColuna, p_lImprime, p_lImpTotal, Iif(p_nTpTotal == 1, 'COUNT', 'SUM')})
	Else
		Self:aColunaImp[nPosImp] := {p_cColuna, p_lImprime, p_lImpTotal, Iif(p_nTpTotal == 1, 'COUNT', 'SUM')}
	EndIf

RETURN


/*/{Protheus.doc} GETCOLIMP
@description Retorna configuracao de impressao da coluna

@author Helitom Silva
@since  07/11/2014

@param p_cColuna, Caracter, Nome da Coluna

/*/
METHOD GETCOLIMP(p_cColuna) CLASS DBGrid
	
	Local aRet	  := {}
	Local nPosImp := 0
	
	If (nPosImp := aScan(Self:aColunaImp, {|X| X[1] = p_cColuna})) > 0
		aRet := Self:aColunaImp[nPosImp]
	Else
		aRet := {'', .F., .F., 1}
	EndIf
	
RETURN aRet


/*/{Protheus.doc} PRINT
@description Imprimir relat�rio com dados da Grid

@author Helitom Silva
@since  07/11/2014

/*/
METHOD PRINT() CLASS DBGrid

	Local oReport

	Self:CREATEALIAS()
		
	oReport := Self:REPORTDEF()		
	oReport:PrintDialog()

RETURN


/*/{Protheus.doc} REPORTDEF
@description Define Layout do relat�rio da Grid

@author Helitom Silva
@since  07/11/2014

/*/
METHOD REPORTDEF() CLASS DBGrid

	Local oReport 
	Local oSection1

	Local aHeadCol := {}
	Local nX 	   := 0
			
	oReport := TReport():New(Self:cRelProgr, Self:cRelTitul, Self:cRelProgr, {|oReport| Self:PRINTREPORT(oReport)}, Self:cRelDescr)
	
	oReport:SetLandScape()
	oReport:ShowHeader()
	oReport:lParamPage := .F.
	oReport:nColSpace  := 2
	
	oSection1 := TRSection():New(oReport, Self:cRelTitul, Self:cRelAlias) 

	For nX := 1 to Self:GETQTDCOLUNA()
		
		If !((nX == Self:GETCOLLEG()) .or. (nX == Self:GETCOLCHK())) .and. Self:GETCOLIMP(Self:NOMECOLUNA(nX))[2]
			
			aHeadCol := Self:GETHEADCOL(Self:NOMECOLUNA(nX))
	
			TRCell():New(oSection1, Self:NOMECOLUNA(nX)	, Self:cRelAlias, aHeadCol[1], aHeadCol[3])
			oSection1:Cell(Self:NOMECOLUNA(nX)):lAutoSize	 := .F.
			oSection1:Cell(Self:NOMECOLUNA(nX)):lPixelSize	 := .F.	
			oSection1:Cell(Self:NOMECOLUNA(nX)):nSize		 := Iif(aHeadCol[4] >= Len(aHeadCol[1]), aHeadCol[4], Len(aHeadCol[1])) + Iif(aHeadCol[8] = 'D', 2, 0)
			oSection1:Cell(Self:NOMECOLUNA(nX)):nAlign		 := Iif(aHeadCol[8] = 'N', 3, 1)
			oSection1:Cell(Self:NOMECOLUNA(nX)):nHeaderAlign := Iif(aHeadCol[8] = 'N', 3, 1)
		 	oSection1:Cell(Self:NOMECOLUNA(nX)):nHeaderSize  := Iif(aHeadCol[4] >= Len(aHeadCol[1]), aHeadCol[4], Len(aHeadCol[1])) + Iif(aHeadCol[8] = 'D', 2, 0)
		 	oSection1:Cell(Self:NOMECOLUNA(nX)):lHeaderSize  := .F.
		 	
			If Self:GETCOLIMP(Self:NOMECOLUNA(nX))[3]
				TRFunction():New(oSection1:Cell(Self:NOMECOLUNA(nX)), "T" + Self:NOMECOLUNA(nX), Self:GETCOLIMP(Self:NOMECOLUNA(nX))[4], Nil, aHeadCol[1], aHeadCol[3], Nil, .F.)
			EndIf

		EndIf
		
	Next
	
RETURN oReport


/*/{Protheus.doc} PRINTREPORT
@description Executa impress�o de relat�rio

@author Helitom Silva
@since  07/11/2014

/*/
METHOD PRINTREPORT(p_oReport) CLASS DBGrid

	Local nL 	   	  := 0
	Local nX 	   	  := 0
	Local aHeadCol 	  := {}	
		
	For nL := 1 to Self:GETQTDLINHA()	
		
		Self:POSLINHA(nL)
		
		RecLock(Self:cRelAlias, .T.)
		
		For nX := 1 to Self:GETQTDCOLUNA()
			
			If !((nX == Self:GETCOLLEG()) .or. (nX == Self:GETCOLCHK()))	
				
				(Self:cRelAlias)->&(Self:NOMECOLUNA(nX)) := Self:GETCOLUNA(Self:NOMECOLUNA(nX))
		
			EndIf
		
		Next
		
		(Self:cRelAlias)->(MsUnLock())
		
	Next
		
	p_oReport:Section(1):Print()

	Self:DELETEALIAS()
					
RETURN


/*/{Protheus.doc} SETPOPUP
@description Define Menus de Contexto, que aparecem ao clicar com o Bot�o direito sobre a Grid.

@author Helitom Silva
@since  07/10/2014

/*/
METHOD SETPOPUP(p_oMenu) CLASS DBGrid
	
	Local oTMenuImp  := TMenuItem():New(GetWndDefault(), "Imprimir",,,,{|| Self:PRINT() },,,,,,,,,.T.)
	Local oTMenuFil  := TMenuItem():New(GetWndDefault(), "Filtrar",,,,{|| Self:FILTER() },,,,,,,,,.T.)
	Local oTMenuPesq := TMenuItem():New(GetWndDefault(), "Pesquisar",,,,{|| Self:SEARCH() },,,,,,,,,.T.)
	
	Default p_oMenu := TMenu():New(0,0,0,0,.T.)
	
	p_oMenu:Add(oTMenuImp)
	p_oMenu:Add(oTMenuPesq)
	/* p_oMenu:Add(oTMenuFil)  Filtro - Em desenvolvimento */
	
	Self:oBrowse:SetPopup(p_oMenu)

RETURN


/*/{Protheus.doc} SETFOCUS
@description Foco no Objeto

@author Helitom Silva
@since  31/10/2014

/*/
METHOD SETFOCUS() CLASS DBGrid

	Self:oBrowse:SetFocus()

RETURN


/*/{Protheus.doc} DESTLINPOS
@description Destaca Linha posicionada com cor diferente.

@author Helitom Silva
@since  31/03/2015

/*/
METHOD DESTLINPOS(p_lDestLnPos) CLASS DBGrid
	
	Default p_lDestLnPos := .T.
	
	Self:lDestLnPos := p_lDestLnPos
	
RETURN


/*/{Protheus.doc} FILTER
@description Filtro

@author Helitom Silva
@since  14/04/2015

/*/
METHOD FILTER() CLASS DBGrid
	
	Local oFilter
	Local nX          := 0
	Local aHeadCol    := {}
	Local aCampos     := {}
	Local cOldFunName := FunName()
	
	__cFunName  := FunName() + 'DG' + cValToChar(Self:oBrowse:nTop + Self:oBrowse:nLeft + Self:oBrowse:nBottom + Self:oBrowse:nRight + Len(Self:hHeader)) 
	
	oFilter := FWFilter():New()

	For nX := 1 to Self:GETQTDCOLUNA()
		
		If !((nX == Self:GETCOLLEG()) .or. (nX == Self:GETCOLCHK()))	
			
			aHeadCol := Self:GETHEADCOL(Self:NOMECOLUNA(nX))
			
			aAdd(aCampos, {aHeadCol[2], aHeadCol[1], aHeadCol[8],  aHeadCol[4],  aHeadCol[5],  aHeadCol[3]})
	
		EndIf
	
	Next
	
	oFilter:SetAlias(Self:CREATEALIAS())
	oFilter:SetOwner(Self)
	oFilter:SetField(aCampos)
	oFilter:SetExecute({|| Self:EXECFILTER(oFilter) })
	
	oFilter:LoadFilter()
	oFilter:Activate()
	oFilter:SaveFilter()

	oFilter:Destroy()

	Self:Refresh()
		
	__cFunName := cOldFunName
	
	Self:DELETEALIAS()
	
RETURN


/*/{Protheus.doc} ExecFiltro
@description Fun��o responsavel por realizar os filtros selecionados pelo usuario 

@author  Helitom Silva
@since 	 10/04/2015
@version 1.0

@param p_oFilter, objeto, Objeto de Filtro

/*/
METHOD EXECFILTER(p_oFilter) CLASS DBGrid
	
	Local cAdvpl := p_oFilter:GetExprADVPL()
		
RETURN


/*/{Protheus.doc} CREATEALIAS
@description Cria Alias temporario

@author Helitom Silva
@since  14/04/2015

/*/
METHOD CREATEALIAS() CLASS DBGrid

	Local aHeadCol 	  := {}	
	Local aStruDBGrid := {}
	
	Self:cDirTemp := "\Temp\"
	Self:cArqTemp := Self:cDirTemp + (Self:cRelAlias := GetNextAlias())
		
	For nX := 1 to Self:GETQTDCOLUNA()
		
		If !((nX == Self:GETCOLLEG()) .or. (nX == Self:GETCOLCHK()))	
			
			aHeadCol := Self:GETHEADCOL(Self:NOMECOLUNA(nX))
			
			aAdd(aStruDBGrid, {aHeadCol[2], aHeadCol[8], aHeadCol[4], aHeadCol[5]})
	
		EndIf
	
	Next
		
	Iif(Select(Self:cRelAlias) > 0, (Self:cRelAlias)->(DbCloseArea()), Nil)
	
	MakeDir(Self:cDirTemp)
	DbCreate(Self:cArqTemp, aStruDBGrid)
	DbUseArea( .T.,, Self:cArqTemp, Self:cRelAlias, .T., .F. )
	
RETURN Self:cRelAlias


/*/{Protheus.doc} DELETEALIAS
@description Deleta Alias temporario

@author Helitom Silva
@since  14/04/2015

/*/
METHOD DELETEALIAS() CLASS DBGrid

	If Select(Self:cRelAlias) > 0
		(Self:cRelAlias)->(DbCloseArea())
    	FErase(Self:cArqTemp + GetDbExtension())
	EndIf
	    
RETURN


/*/{Protheus.doc} SETCOLSORI
@description Define os dados da atual Grid como Original

@author Helitom Silva
@since 30/04/2015

/*/
METHOD SETCOLSORI() CLASS DBGrid

	Self:aColsOri := aClone(Self:aCols)
	
RETURN


/*/{Protheus.doc} GETCOLSORI
@description Retorna os dados da Grid Original

@author Helitom Silva
@since 30/04/2015

/*/
METHOD GETCOLSORI() CLASS DBGrid
RETURN Self:aColsOri


/*/{Protheus.doc} GETCOLSDIF
@description Verifica se houve altera��o nos dados da Grid.

@author Helitom Silva
@since 30/04/2015

/*/
METHOD GETCOLSDIF() CLASS DBGrid
	
	Local lRet := .F.
	Local nX   := 0
	Local nY   := 0
	
	If !(Len(Self:aCols) == Len(Self:aColsOri))
		lRet := .T.
	Else
		For nX := 1 to Len(Self:aColsOri)
			For nY := 1 to Len(Self:aColsOri[nY])
				If !(Self:aColsOri[nX][nY] == Self:aCols[nX][nY])
					lRet := .T.
				EndIf
			Next
		Next
	EndIf
	
RETURN lRet


/*/{Protheus.doc} SETBACKCOLOR
@description Define bloco de codigo da cor de Fundo da Linha.

@author Helitom Silva
@since  13/05/2015

@param p_bBlock, Bloco de Codigo, bloco de codigo da cor de Fundo da Linha

/*/
METHOD SETBACKCOLOR(p_bBlock) CLASS DBGrid
	
	Default p_bBlock := {|| 0}
	
	Self:oBrowse:SetBlkBackColor({|| Iif( Eval(p_bBlock) > 0, Eval(p_bBlock), Eval(Self:bBackColor))})
	
RETURN


/*/{Protheus.doc} SETFONTCOLOR
@description Define bloco de codigo da cor da Fonte da Linha.

@author Helitom Silva
@since  13/05/2015

@param p_bBlock, Bloco de Codigo, bloco de codigo da cor da Fonte da Linha

/*/
METHOD SETFONTCOLOR(p_bBlock) CLASS DBGrid
	
	Default p_bBlock := {|| 0}
	
	Self:oBrowse:SetBlkColor({|| Iif( Eval(p_bBlock) > 0, Eval(p_bBlock), Eval(Self:bFontColor))})
	
RETURN


/*/{Protheus.doc} SEARCH
@description Pesquisar

@author  Helitom Silva
@since   10/08/2015
@version 1.0

/*/
METHOD SEARCH() CLASS DBGrid

	Local oFWLayer   := FWLayer():New()
	
	Private uGetSearch
	Private aCBSearch  := {}
	Private cCBSearch  
	 
	Private oDlgSearch   
	Private oCBSearch   
	Private oGetSearch   
	Private oSBSearch   
	Private oWinSearch   
	
	oDlgSearch   := MSDialog():New( 170, 384, 280, 819, "Pesquisar",,,.F.,  nOr(WS_VISIBLE, WS_POPUP),,,,,.T.,,,.T.,.T. )

	oFWLayer:Init( oDlgSearch, .T., .T. )
	
	oFWLayer:AddLine( 'LSEARCH', 80, .F. )
	oFWLayer:AddCollumn( 'CSEARCH', 100, .T., 'LSEARCH' )
	oFWLayer:addWindow( 'CSEARCH', 'WSEARCH', 'Pesquisar', 100, .F., .T.,, 'LSEARCH'  )

	oWinSearch := oFWLayer:GetWinPanel( 'CSEARCH', 'WSEARCH', 'LSEARCH' ) 

	Self:GETFSEARCH()
		
	oCBSearch  := TComboBox():New( 000, 000, {|u| If(PCount() > 0, cCBSearch := u, cCBSearch)}, aCBSearch,072,010, oWinSearch,, {|| Self:CHGFSEARCH()},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCBSearch )

	Self:CHGFSEARCH()

	oSBSearch  := SButton():New( 000, 185, 1, {|| Self:RUNSEARCH(), oDlgSearch:End()}, oWinSearch,,"", )

	oDlgSearch:lCentered := .T.
	oDlgSearch:lEscClose := .T.	
	oDlgSearch:Activate(,,,.T.)

RETURN


/*/{Protheus.doc} GETFSEARCH
@description Obtem Colunas para Pesquisa.

@author  Helitom Silva
@since   10/08/2015
@version 1.0

/*/
METHOD GETFSEARCH() CLASS DBGrid

	Local nX 	   := 0
	Local aHeadCol := {}
	
	For nX := 1 to Self:GETQTDCOLUNA()
		
		If !((nX == Self:GETCOLLEG()) .or. (nX == Self:GETCOLCHK()))	
			
			aHeadCol := Self:GETHEADCOL(Self:NOMECOLUNA(nX))
			
			aAdd(aCBSearch, AllTrim(aHeadCol[2]) + '=' + AllTrim(aHeadCol[1]))
			
		EndIf
	
	Next
		
RETURN


/*/{Protheus.doc} CHGFSEARCH
@description Alteração da Coluna a ser Pesquisada.

@author  Helitom Silva
@since   10/08/2015
@version 1.0

/*/
METHOD CHGFSEARCH() CLASS DBGrid

	Local aHeadCol := Self:GETHEADCOL(cCBSearch)
	
	uGetSearch := RetDado(aHeadCol[8], aHeadCol[4])

	oGetSearch := TGet():New( 000, 076, {|u| If(PCount() > 0, uGetSearch := u, uGetSearch)}, oWinSearch, 096, 009, aHeadCol[3],,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","uGetSearch",,)	
	oGetSearch:bLostFocus := {|| oSBSearch:SetFocus()}

	oGetSearch:SetFocus()
	
RETURN


/*/{Protheus.doc} RUNSEARCH
@description Executa Pesquisa.

@author  Helitom Silva
@since   10/08/2015
@version 1.0

/*/
METHOD RUNSEARCH() CLASS DBGrid

	Local aHeadCol := Self:GETHEADCOL(cCBSearch)

	If !Empty(AllTrim(uGetSearch))
	
		Self:hnOrd   := 0
		Self:HcOrdem := 'D'
		Self:CLICKCOL(Self:POSCOLUNA(cCBSearch))
		
		Self:SEEKLINHA(cCBSearch, uGetSearch, .F., .T.)
	
	EndIf
			
RETURN


/*/{Protheus.doc} SetOrigem
@description Define Origem
	
@author  Helitom Silva
@since   18/08/2015
@version 1.0		

/*/
Method SETORIGEM(p_cOrigem) Class DBGrid
	
	Self:cOrigem := p_cOrigem
	
Return


/*/{Protheus.doc} GetOrigem
@description Obtem Origem
	
@author  Helitom Silva
@since   18/08/2015
@version 1.0		

/*/
Method GETORIGEM() Class DBGrid
Return Self:cOrigem


/*/{Protheus.doc} SearchOrigem
@description Pesquisa Origem
	
@author  Helitom Silva
@since   18/08/2015
@version 1.0		

/*/
METHOD SEARCHORIGEM() CLASS DBGrid

	Local nX     := 1
	Local cVazio := AllTrim(ProcName(nX))
	
	While !Empty(cVazio)
	   If SubStr(Upper(AllTrim(ProcName(nX))), 1, 2) = 'U_'
	      Self:SETORIGEM(AllTrim(ProcName(nX)))
	      Exit
	   Else
	      nX++
	      cVazio := AllTrim(ProcName(nX))
	   EndIf
	End
	
RETURN