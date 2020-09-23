#define VM_NONE        0
#define VM_NEWREC      16   // Novo registro
#define VM_READ        32   // Leitura de registro
#define VM_INSERT      64   // Inclusao de Registro
#define VM_UPDATE      128  // Alteracao de Registro
#define VM_DELETE      256  // Exclusao de Registro
#define VM_BEGEDIT     512  // Antes de Editar um Campo
#define VM_ENDEDIT     1024  // Apos edicao de um Campo
#define VM_FLDCHANGE   2048  // Campo mudou de valor
#define VM_VIEW        4096  // Registro em consulta
#define VM_AINSERT     8192  // Inclusao de Registro
#define VM_AUPDATE     16384  // Alteracao de Registro
#define VM_ADELETE     32768  // Exclusao de Registro

#define VM_FLDWHEN     65536  // Exclusao de Registro
#define VM_FLDTRIGGER  131072  // Exclusao de Registro
 
#define VLD_REQUIRED   1
#define VLD_ASSIGN     2
 
#define FK_CASCADE  1
#define FK_RESTRICT 2
#define FK_SET_NULL 3

#define SD_INSERT      -64	// Inclusao de Registro
#define SD_UPDATE      -128	// Alteracao de Registro
#define SD_DELETE      -256	// Exclusao de Registro
#define SD_ONCREATE	   -512	// Criacao da tabela

//posicoes do vetor

#define SD_TALIAS	1	//Alias
#define SD_TDESC	2	//Descricao
#define SD_TINDEX	3	//Indices
#define SD_TFIELD	4	//Campos
#define SD_TRULE	5	//Regras
#define SD_TFOLDER	6	//Regras

#define SD_ITYPE	1	//tipo	(PK/IK/FK)
#define SD_IKEY		2	//chave do indice
#define SD_IDESC	3	//descricao

#define SD_FFIELD		1	//Campo
#define SD_FTYPE		2	//Tipo
#define SD_FSIZE		3	//Tamanho
#define SD_FDECIMAL		4	//Decimal
#define SD_FTITLE		5	//Titulo
#define SD_FDESC		6	//Descricao
#define SD_FPICTURE		7	//Picture		VLD_PICTURE
#define SD_FREQUIRED	8	//Obrigatorio	VLD_REQUIRED
#define SD_FVISUAL		9	//Visual		VLD_VISUAL
#define SD_FCOMBOBOX	10	//ComboBox		VLD_COMBOBOX
#define SD_FINITPAD		11	//Inic. padrao	VLD_INITPAD
#define SD_FBROWSE		12	//Browse		VLD_BROWSE
#define SD_FVIRTUAL		13	//Virtual		VLD_VIRTUAL
#define SD_FVALID		14	//Validacao		VM_FLDCHANGE
#define SD_FWHEN		15	//When			VM_FLDWHEN
#define SD_FTRIGGER		16	//Gatilhos		VLD_TRIGGER
#define SD_FFOLDER		17	//Pasta			VLD_FOLDER
#define SD_FORDER		18	//Ordem
#define SD_FUSED		19	//Usado			VLD_NOTUSED
#define SD_FCONPAD		20	//Consulta padrao	VLD_CONPAD
#define SD_FINIBROW		21	//Inicializador do Browse

#define CP_NAME				1	//Nome
#define CP_TITLE			2	//Titulo
#define CP_ALIAS			3	//Alias
#define CP_FIELD			4	//Campos
#define CP_RETURN			5	//Retorno
#define CP_FILTER			6	//Filtro
#define CP_INDEX			7	//Indice
#define CP_INSERT			8	//Incluir
#define CP_MODIFY			9	//Modificar
#define CP_INSERTFUNCTION	10	//Funcao para Incluir
#define CP_MODIFYFUNCTION	11	//Funcao para Modificar
#define CP_VIEWFUNCTION		12	//Funcao para Visualizar
#define CP_TYPE				13	//Tipo de consulta