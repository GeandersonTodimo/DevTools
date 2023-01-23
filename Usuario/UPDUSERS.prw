#INCLUDE "TOTVS.CH"


/*/{Protheus.doc} UPDUSERS
Lista os usuarios para realizar a alteração de senha.
@type function
@version 1.0 
@author geanderson.silva
@since 20/01/2023
/*/
User Function UPDUSERS

    local cUserAlias := "USERSTMP"

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
            AND USR_ID NOT IN ('000000')
    EndSql

    DBSelectArea(cUserAlias)
    While (cUserAlias)->(!Eof())
        if !U_UPDUSRPW((cUserAlias)->USR_ID)
            varinfo("Houve erro no usuario id ->",(cUserAlias)->USR_ID)
        endif
        (cUserAlias)->(DbSkip())
    EndDo

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
    local oRestClient := nil
    local cUrl := ""
    local cPath := ""
    local aHeadOut := {}

    cUrl := "http://192.168.240.48:3905/REST"
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
    if pUserId $ '001391/001242'
        cBody +=    '"password":"20406080"'
    else
        cBody +=    '"password":"TESTE"'
    endif
    cBody +=    '}'
    
    Aadd(aHeadOut, "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InBKd3RQdWJsaWNLZXlGb3IyNTYifQ.eyJpc3MiOiJUT1RWUy1BRFZQTC1GV0pXVCIsInN1YiI6IkdFQU5ERVJTT04uU0lMVkEiLCJpYXQiOjE2NzQ0NzU0MDQsInVzZXJpZCI6IjAwMTM5MSIsImV4cCI6MTY3NDQ3OTAwNCwiZW52SWQiOiJQMTJURVNURV8zIn0.enwzTbEG9fXw1LerwO7LZaeKaDCuCfzKAHrgji0L2YkWdd8ObWiigwzTRQk6Q6uO2FFphECphtALunwxY29peihscVS1n2r652aag8oaSE3F7ODQnMZ8Nagl_lyY3Y_GWuIOeHGkwzS9hiYCutp87Rs2jEk7DN9KX2HyMZY7-Q7qE1-mDwWvZRCMPbQZExnD2iFXhbK2KLbprpO6qtsjQIodr9Dvqol-4yTxOkRkmWsBTBCID-bcwE7-BiGUQMdhPTuha4mu1IflVUIsrLPAaHy9kFpvn7YNOAkE4plcs_oPJJtX7IY82ItZ5FKsaQFK4Fh6r3WmwYjdrUR_YZe9bA")
    Aadd(aHeadOut, "Content-Type: application/json")

    oRestClient := FWRest():New(cUrl)
    oRestClient:setPath(cPath)

    if oRestClient:Put(aHeadOut,cBody)
        varinfo("Var oRestClient:GetResult()",oRestClient:GetResult())
        lRet := .t.
    else
        varinfo("Var oRestClient:GetLastError()",oRestClient:GetLastError())
    endif

    // PswOrder(1)
    // lSeek := PswSeek("GEANDERSON.SILVA",.t.)

Return lRet