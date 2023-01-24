#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} UPDUSERS
Lista os usuarios para realizar a alteração de senha.
@type function
@version 1.0 
@author geanderson.silva
@since 20/01/2023
/*/
User Function UPDUSERS

    local lRet := .f.
    local cUserAlias := "USERSTMP"
    local cPathUser := ""
    local strJson := Nil
    local lenStrJson := 0
    local jsonfields := {}
    local nRetParser := 0
    local keyVal, keyType
    // Private oJsonRet := tJsonParser():New()
    local oJsonRet := JsonObject():new()
    local oExecUtil := TDGE003C():New()

    private cEndAPI := "" //Vai obter a url da API no arquivo de configuração
    Private aHeadOut := {}
    Private oRestClient := nil

    U_ATUACONFIG() //Obtem os parãmentros de configuração do arquivo
    oExecUtil:Login(.f.)
    if ValType(oExecUtil:jTDGE003C['PASSWORD']) == "C"
        oRestClient := FWRest():New(cEndAPI)
        Aadd(aHeadOut, "Content-Type: application/json")
        cPathUser := "/api/oauth2/v1/token?grant_type=password&password="+Alltrim(oExecUtil:jTDGE003C['PASSWORD'])+"&username="+Alltrim(oExecUtil:jTDGE003C['USERNAME'])+""
        oRestClient:setPath(cPathUser)
    endif

    if oRestClient:Post(aHeadOut)
        varinfo("Var oRestClient:GetResult()",oRestClient:GetResult())
        strJson := oRestClient:GetResult()
        oJsonRet:fromJson(strJson)
        lRet := oJsonRet:GetJsonValue("access_token", @keyVal, @keyType)
        If ( !lRet )
            varinfo("Erro ao criar o objeto json")
        Else
            Aadd(aHeadOut, "Authorization: Bearer "+keyVal)
        EndIf
    else
        varinfo("Var oRestClient:GetLastError()",oRestClient:GetLastError())
    endif

    if lRet
        BeginSql Alias cUserAlias
            SELECT
                USR_ID,
                USR_CODIGO,
                USR_NOME,
                USR_EMAIL
            FROM
                SYS_USR
            WHERE
                D_E_L_E_T_ = ' ' 
                AND USR_MSBLQL = '2'
                AND USR_ID NOT IN ('000000','001496','001288','001287','001445','001446','001497','001289','001447','001443','001444','001495','001495','001391','001242')
                AND NOT USR_CODIGO LIKE 'JOB%'
        EndSql

        DBSelectArea(cUserAlias)
        While (cUserAlias)->(!Eof())
            if !U_UPDUSRPW((cUserAlias)->USR_ID)
                varinfo("Houve erro no usuario id ->",(cUserAlias)->USR_ID)
            endif
            (cUserAlias)->(DbSkip())
        EndDo
    endif

	oExecUtil := Nil
	FreeObj(oExecUtil)

Return


/*/{Protheus.doc} UPDUSRPW
Função que executa o metodo PUT e altera a senha do usuario.
@type function
@version 1.0 
@author geanderson.silva
@since 20/01/2023
@param pUserId, character, código do usuario.
@return logical, Alterado com sucesso.
/*/
User Function UPDUSRPW(pUserId)

    local lRet := .f.
    local cPath := ""

    cPath := "/api/framework/v1/users/"+pUserId+""

    cBody :=    '{'
    cBody +=    '"schemas":['       
    cBody +=    '"urn:scim:schemas:core:2.0:User",'
    cBody +=    '"urn:scim:schemas:extension:enterprise:2.0:User"'
    cBody +=    '],'
    cBody +=    '"emails": ['
    cBody +=    '{'
    cBody +=    '"value": "'+pUserId+'teste@todimo.com.br",'
    cBody +=    '"primary": true'
    cBody +=    '}'
    cBody +=    '],'
    cBody +=    '"password":"TODIMO2023"'
    cBody +=    '}'
    
    oRestClient:setPath(cPath)

    if oRestClient:Put(aHeadOut,cBody)
        varinfo("Var oRestClient:GetResult()",oRestClient:GetResult())
        lRet := .t.
    else
        varinfo("Var oRestClient:GetLastError()",oRestClient:GetLastError())
    endif

Return lRet